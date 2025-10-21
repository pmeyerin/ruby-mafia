class RoundsController < ApplicationController
  def create
    @game = Game.find(params[:round][:game_id])
    current_round = Round.where(game_id: @game.id, round_number: Round.where(game_id: @game.id).maximum(:round_number)).first
    if current_round == nil
      assign_player_roles(@game)
      Round.create(game_id: @game.id, round_number: 1, game_phase: GAME_PHASE[:NIGHT])
    else
      Round.create(game_id: @game.id, round_number: current_round.round_number + 1, game_phase: params[:game_phase])
    end
    redirect_to game_path(@game)
  end

  private
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
end
