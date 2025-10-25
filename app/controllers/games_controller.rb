class GamesController < ApplicationController
  allow_unauthenticated_access only: %i[index show]

  # def initialize
  #   @round_service = RoundService.new
  #   @game_service = GameService.new
  # end
  def index
    if authenticated?
      @logged_in_user = Current.user.id
      @my_games = Game.where(id: Player.where(user_id: @logged_in_user).select("game_id"))
      @avail_games = Game.where.not(id: Game.joins(:round).select("games.id"))
                         .where.not(id: Player.where(user_id: @logged_in_user).select("game_id"))
      @player = Player.new
    else
      @avail_games = Game.where.not(id: Game.joins(:round).select("games.id"))
      @my_games = []
    end
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      redirect_to games_path
    else
      render :new, status: :unprocessable_content
    end
  end

  def show
    @game = Game.find(params[:id])
    current_round = RoundService.get_current_round(@game)
    @player_action = PlayerAction.new
    if authenticated?
      @player = Player.where(user_id: Current.user.id, game_id: @game.id).first
      if current_round
        @player_action = PlayerAction.where(round_id: current_round.id, player_id: @player.id).first
        unless @player_action
          @player_action = PlayerAction.new
        end
      end
    end
  end

  def update_phase
    @game = Game.find(params[:id])
    current_round = Round.where(game_id: @game.id).maximum(:round_number)
    if current_round == nil
      assign_player_roles(@game)
      Round.create(game_id: @game.id, round_number: 1, game_phase: GAME_PHASE[:NIGHT])
    else
      Round.create(game_id: @game.id, round_number: current_round.round_number + 1, game_phase: params[:game_phase])
      if @game.save
        redirect_to game_path(@game)
      else
        render :show, status: :unprocessable_content
      end
    end
  end

  private
  def find_mafiosi_target(previous_round)
    if previous_round
      mafiosi_votes = PlayerAction.where(round_id: previous_round.id, player_id: Player.where(game_id: previous_round.game_id, role: PLAYER_ROLE[:MAFIOSO]))
      if mafiosi_votes.count > 0
        chosen_target = mafiosi_votes[0].target_id
        mafiosi_votes.each do |vote|
          if vote.target_id != chosen_target
            return nil
          end
        end
        return Player.find(chosen_target)
      end
    end
    nil
  end
  def find_previous_chosen_player(game, current_round)
    if current_round == nil or current_round.round_number <= 1
      return # No one has a previous action because it is the first rounds.
    end

    previous_round = Round.where(game_id: current_round.game_id, round_number: current_round.round_number - 1).first
    raw_votes = PlayerAction.where(round_id: previous_round.id)
    tallied_votes = {}

    raw_votes.each do |vote|
      voted_player = Player.find(vote.target_id)
      if tallied_votes[voted_player]
        tallied_votes[voted_player] = tallied_votes[voted_player] + 1
      else
        tallied_votes[voted_player] = 1
      end
    end

    tallied_votes = tallied_votes.sort_by(&:last).reverse.to_h

    tallied_votes.each do |player, votes|
      if votes >= game.player.filter { |lifeCheck| lifeCheck.alive == true }.count / 2
        return player
      end
    end

    nil
  end
  def game_params
    params.expect(game: [ :name,  :min_players, :max_players, :use_detective, :use_doctor, :mafioso_ratio ])
  end
end
