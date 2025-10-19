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

  private
  def player_params
    params.expect(player: [ :name,  :minPlayers, :maxPlayers, :useInformant, :useLawyer, :useVigilante, :useDetective, :useDoctor, :gamePhase, :players, :mafiosoRatio, :linkPhrase ])
  end
end
