require "test_helper"

class PlayerActionControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test "fixtures work" do
    # ActiveRecord::FixtureSet.create_fixtures("test/fixtures", "users")

    assert User.count == 6
    assert_equal 1, Game.count
    assert_equal 6, Player.count
    assert_equal 0, Round.count
    assert_equal 0, PlayerAction.count
  end

  test "new player action" do
    this_game = games(:one)
    acting_round = Round.create(game_id: this_game.id, game_phase: 1, round_number: 1)
    assert_difference "PlayerAction.count", 1 do
      post player_actions_path, params: { player_action: { target_id: players(:two).id, player_id: players(:one).id, round_id: acting_round.id } }
    end
    assert_response :redirect
    assert_redirected_to game_path(this_game)
    assert_equal players(:two).id, PlayerAction.last.target_id
  end

  test "update player action" do
    this_game = games(:one)
    acting_round = Round.create(game_id: this_game.id, game_phase: 1, round_number: 1)
    action = PlayerAction.create(target_id: players(:three).id, player_id: players(:one).id, round_id: acting_round.id)
    put player_action_path(action), params: { player_action: { target_id: players(:two).id, player_id: players(:one).id, round_id: acting_round.id } }

    assert_equal players(:two).id, PlayerAction.last.target_id
    assert_response :redirect
    assert_redirected_to game_path(this_game)
  end

  test "round ending action" do
    this_game = games(:one)
    acting_round = Round.create(game_id: this_game.id, game_phase: GAME_PHASE[:DAY], round_number: 1)
    PlayerAction.create(target_id: players(:three).id, player_id: players(:one).id, round_id: acting_round.id)
    PlayerAction.create(target_id: players(:three).id, player_id: players(:two).id, round_id: acting_round.id)
    PlayerAction.create(target_id: players(:four).id, player_id: players(:three).id, round_id: acting_round.id)
    PlayerAction.create(target_id: players(:three).id, player_id: players(:four).id, round_id: acting_round.id)
    PlayerAction.create(target_id: players(:three).id, player_id: players(:five).id, round_id: acting_round.id)
    post player_actions_path, params: { player_action: { target_id: players(:three).id, player_id: players(:six).id, round_id: acting_round.id } }
    assert_response :redirect
    assert_redirected_to game_path(this_game)
    assert_equal players(:three).id, PlayerAction.last.target_id
    assert_equal 2, Round.last.round_number
    assert_equal GAME_PHASE[:NIGHT], Round.last.game_phase
    assert_equal false, Player.find(players(:three).id).alive
  end

  test "tied votes does not end round" do
    this_game = games(:one)
    acting_round = Round.create(game_id: this_game.id, game_phase: GAME_PHASE[:DAY], round_number: 1)
    PlayerAction.create(target_id: players(:four).id, player_id: players(:one).id, round_id: acting_round.id)
    PlayerAction.create(target_id: players(:four).id, player_id: players(:two).id, round_id: acting_round.id)
    PlayerAction.create(target_id: players(:four).id, player_id: players(:three).id, round_id: acting_round.id)
    PlayerAction.create(target_id: players(:three).id, player_id: players(:four).id, round_id: acting_round.id)
    PlayerAction.create(target_id: players(:three).id, player_id: players(:five).id, round_id: acting_round.id)
    post player_actions_path, params: { player_action: { target_id: players(:three).id, player_id: players(:six).id, round_id: acting_round.id } }
    assert_response :redirect
    assert_redirected_to game_path(this_game)
    assert_equal players(:three).id, PlayerAction.last.target_id
    assert_equal 1, Round.last.round_number
    assert_equal GAME_PHASE[:DAY], Round.last.game_phase
    assert_equal true, Player.find(players(:three).id).alive
    assert_equal true, Player.find(players(:four).id).alive
  end

  test "doctor saves victim" do
    this_game = games(:one)
    acting_round = Round.create(game_id: this_game.id, game_phase: GAME_PHASE[:NIGHT], round_number: 1)
    # PlayerAction.create(target_id: players(:four).id, player_id: players(:one).id, round_id: acting_round.id)
    # PlayerAction.create(target_id: players(:four).id, player_id: players(:two).id, round_id: acting_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:three).id, round_id: acting_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:four).id, round_id: acting_round.id)
    PlayerAction.create(target_id: players(:three).id, player_id: players(:five).id, round_id: acting_round.id)
    post player_actions_path, params: { player_action: { target_id: players(:one).id, player_id: players(:six).id, round_id: acting_round.id } }
    assert_response :redirect
    assert_redirected_to game_path(this_game)
    assert_equal players(:one).id, PlayerAction.last.target_id
    assert_equal 2, Round.last.round_number
    assert_equal GAME_PHASE[:DAY], Round.last.game_phase
    assert_equal true, Player.find(players(:one).id).alive
  end

  private
  def sign_in(user)
    post sessions_url, params: { email_address: user.email_address, password: "password" }
  end
end
