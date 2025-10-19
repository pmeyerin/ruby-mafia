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

  # def patch_player
  #   @player = Player.find(params[:id])
  #   if params[:action_target]
  #     PlayerAction.create(player_id: @player.id,
  #                         target_id: params[:action_target],
  #                         rounds_id: Round.where(game_id: @player.game_id).maximum(:round_number))
  #   end
  #
  #   @player.save
  #
  #   if params[:game_redirect]
  #     this_game = Game.find(params[:game_redirect])
  #     if check_all_players_acted(this_game)
  #       resolve_end_of_round(this_game)
  #     end
  #     redirect_to this_game
  #   else
  #     redirect_to games_path
  #   end
  # end

  private

  def player_params
    params.expect(player: [ :name,  :minPlayers, :maxPlayers, :useInformant, :useLawyer, :useVigilante, :useDetective, :useDoctor, :gamePhase, :players, :mafiosoRatio, :linkPhrase ])
  end
end
