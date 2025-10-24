require "test_helper"

class RoundControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end
  test "first round gives detective guesses" do
    Game.find(games(:one).id).update(remaining_detective_investigations: 0)
    assert_difference "Round.count", 1 do
      post rounds_path, params: { round: { game_phase: GAME_PHASE[:NIGHT], game_id: games(:one).id } }
    end
    new_round = Round.last
    assert_equal games(:one).id, new_round.game_id
    assert_equal new_round.game_phase, GAME_PHASE[:NIGHT]
    assert_equal 2, Game.find(games(:one).id).remaining_detective_investigations
  end

  private
  def sign_in(user)
    post sessions_url, params: { user_name: user.user_name, password: "password" }
  end
end
