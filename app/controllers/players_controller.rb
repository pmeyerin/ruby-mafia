class PlayersController < ApplicationController
  def new
    @game_id = params[:game_id]
    @user_id = Current.user.id
    @player = Player.new
  end

  def create
    @player = Player.new(params.expect(player: [ :display_name, :game_id, :user_id, :alive ]))
    if @player.save
      redirect_to games_path
    else
      render :new, status: :unprocessable_content
    end
  end

  def patch_player
    @player = Player.find(params[:id])
    if params[:action_target]
      @player.action_target_id = params[:action_target]
    end

    @player.save

    if params[:game_redirect]
      this_game = Game.find(params[:game_redirect])
      if check_all_players_acted(this_game)
        resolve_end_of_round(this_game)
      end
      redirect_to this_game
    else
      redirect_to games_path
    end
  end

  private
    def resolve_end_of_round(game)
      if game.game_phase == GAME_PHASE[:DAY] and find_chosen_player(game) != nil
        resolve_day(game)
      elsif game.game_phase == GAME_PHASE[:NIGHT]
        resolve_night(game) # We are here because it is day, but we have no one has gotten enough votes to be eliminated
      else
        return
      end
      if game.game_phase == GAME_PHASE[:DAY]
        game.update(game_phase: GAME_PHASE[:NIGHT])
      else
        game.update(game_phase: GAME_PHASE[:DAY])
      end
      game.player.each { |player| player.update(prev_action_target_id: player.action_target_id, action_target_id: nil) }
    end

    def resolve_night(game)
      mafiosi = Player.where(game_id: game.id, role: PLAYER_ROLE[:MAFIOSO], alive: true)
      chosen_target = mafiosi[0].action_target_id
      mafiosi.each do |mafioso|
        if mafioso.action_target_id != chosen_target
          # Mafiosi failed to reach unanimity on a target, so no one is attacked
          return
        end
      end

      doctor = Player.where(game_id: game.id, role: PLAYER_ROLE[:DOCTOR], alive: true).first
      if doctor and doctor.action_target_id != chosen_target
        Player.find(chosen_target).update(alive: false)
      end
    end

    def resolve_day(game)
      chosen_player = find_chosen_player(game)

      if chosen_player
        chosen_player.update(alive: false)
      end
    end

    def find_chosen_player(game)
      raw_votes = game.player.filter { |player| player.alive == true }.map { |player|  player.action_target_id }
      tallied_votes = {}

      raw_votes.each do |vote|
        voted_player = Player.find(vote)
        if tallied_votes[voted_player]
          tallied_votes[voted_player] = tallied_votes[voted_player] + 1
        else
          tallied_votes[voted_player] = 1
        end
      end

      tallied_votes.each do |player, votes|
        if votes >= game.player.filter { |lifeCheck| lifeCheck.alive == true }.count / 2
          return player
        end
      end

      nil
    end

    def check_all_players_acted(game)
      game.player.filter { |player| player.alive == true and player.role != PLAYER_ROLE[:VILLAGER] and player.action_target_id == nil }.count == 0
    end

    def player_params
      params.expect(player: [ :name,  :minPlayers, :maxPlayers, :useInformant, :useLawyer, :useVigilante, :useDetective, :useDoctor, :gamePhase, :players, :mafiosoRatio, :linkPhrase ])
    end
end
