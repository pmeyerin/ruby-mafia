class PlayerActionsController < ApplicationController
  def create
    @player_action = PlayerAction.new(player_action_params)
    this_game = Game.find(Round.where(id: params[:player_action][:round_id]).select("game_id"))
    if @player_action.save
      if all_players_acted(this_game)
        resolve_end_of_round(this_game)
      end
      redirect_to game_path(this_game)
    else
      redirect_to game_path(this_game), status: :unprocessable_content
    end
  end

  def update
    @player_action = PlayerAction.find(params[:id])
    this_game = Game.find(Round.where(id: params[:player_action][:round_id]).select("game_id"))
    if @player_action.update(target_id: params[:player_action][:target_id])
      if all_players_acted(this_game)
        resolve_end_of_round(this_game)
      end
      redirect_to game_path(this_game)
    else
      redirect_to game_path(this_game), status: :unprocessable_content
    end
  end

  private
  def player_action_params
    params.expect(player_action: [ :player_id,  :round_id, :target_id ])
  end

  def all_players_acted(game)
    current_round = Round.where(game_id: game.id, round_number: Round.where(game_id: game.id).maximum(:round_number)).first
    expected_action_count = game.player.filter { |player| player.alive == true }.count
    if current_round.game_phase == GAME_PHASE[:NIGHT]
      expected_action_count = game.player.filter { |player| player.alive == true and player.role != PLAYER_ROLE[:VILLAGER] }.count
      if game.remaining_detective_investigations <= 0
        expected_action_count = expected_action_count - 1
      end
    end
    PlayerAction.where(round_id: current_round.id).count == expected_action_count
  end
  def resolve_end_of_round(game)
    current_round = Round.where(game_id: game.id, round_number: Round.where(game_id: game.id).maximum(:round_number)).first
    if current_round.game_phase == GAME_PHASE[:DAY] and find_chosen_player(game, current_round) != nil
      resolve_day(game, current_round)
    elsif current_round.game_phase == GAME_PHASE[:NIGHT]
      resolve_night(game, current_round)
    else
      return # We are here because it is day, but we have no one has gotten enough votes to be eliminated
    end
    if current_round.game_phase == GAME_PHASE[:DAY]
      Round.create(game_id: game.id, game_phase: GAME_PHASE[:NIGHT], round_number: current_round.round_number + 1)
    else
      Round.create(game_id: game.id, game_phase: GAME_PHASE[:DAY], round_number: current_round.round_number + 1)
    end
  end

  def resolve_night(game, current_round)
    if current_round
      chosen_target = find_mafia_attack_target(game, current_round)
      if chosen_target
        doctor_target = PlayerAction.where(round_id: current_round.id,
                                           player_id: Player.where(game_id: game.id, role: PLAYER_ROLE[:DOCTOR], alive: true))
                                    .select("target_id").first
        if doctor_target == nil or doctor_target.target_id != chosen_target.id
          chosen_target.update(alive: false)
        end
      end
      detective_target = PlayerAction.where(round_id: current_round.id,
                                         player_id: Player.where(game_id: game.id, role: PLAYER_ROLE[:DETECTIVE], alive: true)).first
      if detective_target and detective_target.target_id != detective_target.player_id and game.remaining_detective_investigations > 0
        game.update(remaining_detective_investigations: game.remaining_detective_investigations - 1)
        if detective_target.target.role == PLAYER_ROLE[:MAFIOSO]
          detective_target.target.update(alive: false)
        end
      end
    end
  end

  def resolve_day(game, current_round)
    chosen_player = find_chosen_player(game, current_round)

    if chosen_player
      chosen_player.update(alive: false)
    end
  end

  def find_chosen_player(game, current_round)
    raw_votes = PlayerAction.where(round_id: current_round.id)
    tallied_votes = {}

    raw_votes.each do |vote|
      voted_player = Player.find(vote.target_id)
      if tallied_votes[voted_player]
        tallied_votes[voted_player] = tallied_votes[voted_player] + 1
      else
        tallied_votes[voted_player] = 1
      end
    end

    at_least_half = Array.new
    tallied_votes.each do |player, votes|
      if votes >= game.player.filter { |lifeCheck| lifeCheck.alive == true }.count / 2.0
        at_least_half << player
      end
    end

    if at_least_half.count == 1
      return at_least_half[0]
    end

    nil
  end

  def find_mafia_attack_target(game, current_round)
    mafiosi_votes = PlayerAction.where(round_id: current_round.id, player_id: Player.select("id").where(game_id: game.id, role: PLAYER_ROLE[:MAFIOSO]))
    if mafiosi_votes.count > 0
      chosen_target = mafiosi_votes[0].target_id
      mafiosi_votes.each do |vote|
        if vote.target_id != chosen_target
          current_round.update(mafiosi_vote_fail_count: current_round.mafiosi_vote_fail_count + 1)
          if current_round.mafiosi_vote_fail_count >= 3
            return nil
          end
        end
      end
      return Player.find(chosen_target)
    end
    nil
  end
end
