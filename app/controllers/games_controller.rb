class GamesController < ApplicationController
  def index
    @logged_in_user = Current.user.id
    @avail_games = Game.where(game_phase: 2).where.not(id: Player.where(user_id: @logged_in_user).select("game_id"))
    @my_games = Game.where(id: Player.where(user_id: @logged_in_user).select("game_id"))
    @player = Player.new
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
    @player = Player.where(user_id: Current.user.id, game_id: @game.id).first
    if @game.game_phase != GAME_PHASE[:PENDING_START]
      @non_mafiosi = Player.where(game_id: @game.id, alive: true).where.not(role: PLAYER_ROLE[:MAFIOSO])
      @mafiosi = Player.where(game_id: @game.id, role: PLAYER_ROLE[:MAFIOSO], alive: true)
      @game_over = false
      if (@mafiosi.count == 0) or (@non_mafiosi.count == @mafiosi.count)
        @game_over = true
      end
      if @game.game_phase == GAME_PHASE[:DAY]
        @voting_for_me = Player.where(game_id: @game.id, action_target_id: @player)

        @mafiosi_target = find_mafiosi_target
        if @mafiosi_target
          @doctor_saved = false
          doctor = Player.where(game_id: @game.id, role: PLAYER_ROLE[:DOCTOR]).first
          if doctor and doctor.prev_action_target_id == @mafiosi_target.id
            @doctor_saved = true
          end

          @detective_saw = false
          detective = Player.where(game_id: @game.id, role: PLAYER_ROLE[:DETECTIVE]).first
          if detective and detective.prev_action_target_id == @mafiosi_target.id
            @detective_saw = true
          end
        end
      else
        @eliminated_player = find_previous_chosen_player(@game)
      end
    end
  end

  def update_phase
    @game = Game.find(params[:id])
    if @game.game_phase == 2
      assign_player_roles(@game)
    end
    @game.game_phase = params[:game_phase]
    if @game.save
      redirect_to game_path(@game)
    else
      render :show, status: :unprocessable_content
    end
  end

  private
    def find_mafiosi_target
      if @mafiosi[0].prev_action_target_id
        @mafiosi_target = Player.find(@mafiosi[0].prev_action_target_id)
        @mafiosi.each do |mafioso|
          if @mafiosi_target and mafioso.prev_action_target_id != @mafiosi_target.id
            @mafiosi_target = nil
            break
          end
        end
        return @mafiosi_target
      end
      nil
    end
    def find_previous_chosen_player(game)
      raw_votes = game.player.filter { |player| player.alive == true and player.prev_action_target_id != nil }.map { |player|  player.prev_action_target_id }

      if raw_votes.count == 0
        return # No one has a previous action because it is the first round.
      end

      tallied_votes = {}

      raw_votes.each do |vote|
        voted_player = Player.find(vote)
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
    def assign_player_roles(game)
      player_indices = Array.new(game.player.count)

      index = 0
      qty_mafioso = (game.player.count / game.mafioso_ratio).to_i
      while index < qty_mafioso do
        player_indices[index] = PLAYER_ROLE[:MAFIOSO]
        index = index + 1
      end

      if game.use_detective
        player_indices[index] = PLAYER_ROLE[:DETECTIVE]
        index = index + 1
      end

      if game.use_doctor
        puts "DOCTOR? #{PLAYER_ROLE[:DOCTOR]}"
        player_indices[index] = PLAYER_ROLE[:DOCTOR]
        index = index + 1
      end

      while index < game.player.count do
        player_indices[index] = PLAYER_ROLE[:VILLAGER]
        index = index + 1
      end

      player_indices = player_indices.shuffle

      role_index = 0

      game.player.each do |player|
        player.update(role: player_indices[role_index])
        role_index = role_index + 1
      end
    end
    def game_params
      params.expect(game: [ :name,  :min_players, :max_players, :use_detective, :use_doctor, :game_phase, :mafioso_ratio ])
    end
end
