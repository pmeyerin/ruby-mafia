require "test_helper"

class RoundServiceTest < ActiveSupport::TestCase
  test "finds target" do
    this_round = Round.create(game_id: games(:one).id, round_number: 1, game_phase: GAME_PHASE[:NIGHT])
    PlayerAction.create(target_id: players(:one).id, player_id: players(:one).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:two).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:two).id, player_id: players(:three).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:two).id, player_id: players(:four).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:five).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:six).id, round_id: this_round.id)
    result = RoundService.find_mafia_target(Round.find(this_round.id))
    assert_equal players(:two).id, result.id
  end
  test "no result for day time" do
    this_round = Round.create(game_id: games(:one).id, round_number: 1, game_phase: GAME_PHASE[:DAY])
    PlayerAction.create(target_id: players(:one).id, player_id: players(:one).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:two).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:two).id, player_id: players(:three).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:two).id, player_id: players(:four).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:five).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:six).id, round_id: this_round.id)
    result = RoundService.find_mafia_target(Round.find(this_round.id))
    assert_nil result
  end
  test "no result when not unanimous" do
    this_round = Round.create(game_id: games(:one).id, round_number: 1, game_phase: GAME_PHASE[:DAY])
    PlayerAction.create(target_id: players(:one).id, player_id: players(:one).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:two).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:two).id, player_id: players(:three).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:three).id, player_id: players(:four).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:five).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:six).id, round_id: this_round.id)
    result = RoundService.find_mafia_target(Round.find(this_round.id))
    assert_nil result
  end
  test "find doctor target" do
    this_round = Round.create(game_id: games(:one).id, round_number: 1, game_phase: GAME_PHASE[:DAY])
    PlayerAction.create(target_id: players(:one).id, player_id: players(:one).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:two).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:two).id, player_id: players(:three).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:three).id, player_id: players(:four).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:five).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:five).id, player_id: players(:six).id, round_id: this_round.id)
    result = RoundService.singular_target_by_role(Round.find(this_round.id), PLAYER_ROLE[:DOCTOR])
    assert_equal players(:five).id, result.id
  end
  test "no target for role" do
    this_round = Round.create(game_id: games(:one).id, round_number: 1, game_phase: GAME_PHASE[:DAY])
    PlayerAction.create(target_id: players(:one).id, player_id: players(:one).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:two).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:two).id, player_id: players(:three).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:three).id, player_id: players(:four).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:five).id, round_id: this_round.id)
    result = RoundService.singular_target_by_role(Round.find(this_round.id), PLAYER_ROLE[:DOCTOR])
    assert_nil result
  end
  test "find doctor saved" do
    this_round = Round.create(game_id: games(:one).id, round_number: 1, game_phase: GAME_PHASE[:NIGHT])
    PlayerAction.create(target_id: players(:one).id, player_id: players(:one).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:two).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:three).id, player_id: players(:three).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:three).id, player_id: players(:four).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:five).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:three).id, player_id: players(:six).id, round_id: this_round.id)
    result = RoundService.singular_target_by_role(Round.find(this_round.id), PLAYER_ROLE[:DOCTOR])
    assert_equal players(:three).id, result.id
  end
  test "find doctor saved wrong player" do
    this_round = Round.create(game_id: games(:one).id, round_number: 1, game_phase: GAME_PHASE[:NIGHT])
    PlayerAction.create(target_id: players(:one).id, player_id: players(:one).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:two).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:three).id, player_id: players(:three).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:three).id, player_id: players(:four).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:five).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:four).id, player_id: players(:six).id, round_id: this_round.id)
    result = RoundService.doctor_saved(Round.find(this_round.id))
    assert_not result
  end
  test "no doctor action" do
    this_round = Round.create(game_id: games(:one).id, round_number: 1, game_phase: GAME_PHASE[:NIGHT])
    PlayerAction.create(target_id: players(:one).id, player_id: players(:one).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:two).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:three).id, player_id: players(:three).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:three).id, player_id: players(:four).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:five).id, round_id: this_round.id)
    result = RoundService.singular_target_by_role(Round.find(this_round.id), PLAYER_ROLE[:DOCTOR])
    assert_nil result
  end
  test "vote out player" do
    this_round = Round.create(game_id: games(:one).id, round_number: 1, game_phase: GAME_PHASE[:DAY])
    PlayerAction.create(target_id: players(:two).id, player_id: players(:one).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:two).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:three).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:four).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:five).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:six).id, round_id: this_round.id)
    result = RoundService.find_eliminated_player(Round.find(this_round.id))
    assert_equal players(:one).id, result.id
  end
  test "tie means null" do
    this_round = Round.create(game_id: games(:one).id, round_number: 1, game_phase: GAME_PHASE[:DAY])
    PlayerAction.create(target_id: players(:two).id, player_id: players(:one).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:two).id, player_id: players(:two).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:two).id, player_id: players(:three).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:four).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:five).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:six).id, round_id: this_round.id)
    result = RoundService.find_eliminated_player(Round.find(this_round.id))
    assert_nil result
  end
  test "handle odds" do
    this_round = Round.create(game_id: games(:one).id, round_number: 1, game_phase: GAME_PHASE[:DAY])
    PlayerAction.create(target_id: players(:two).id, player_id: players(:one).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:two).id, player_id: players(:two).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:three).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:four).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:five).id, round_id: this_round.id)
    result = RoundService.find_eliminated_player(Round.find(this_round.id))
    assert_equal players(:one).id, result.id
  end
  test "get latest round" do
    Round.create(game_id: games(:one).id, round_number: 1, game_phase: GAME_PHASE[:NIGHT])
    Round.create(game_id: games(:one).id, round_number: 2, game_phase: GAME_PHASE[:DAY])
    Round.create(game_id: games(:one).id, round_number: 3, game_phase: GAME_PHASE[:NIGHT])
    Round.create(game_id: games(:one).id, round_number: 4, game_phase: GAME_PHASE[:DAY])
    result = RoundService.get_current_round(Game.find(games(:one).id))
    assert_equal Round.last.id, result.id
    assert_equal 4, result.round_number
  end
  test "nil round when none yet exist" do
    result = RoundService.get_current_round(Game.find(games(:one).id))
    assert_nil result
  end
  test "get previous round" do
    Round.create(game_id: games(:one).id, round_number: 1, game_phase: GAME_PHASE[:NIGHT])
    Round.create(game_id: games(:one).id, round_number: 2, game_phase: GAME_PHASE[:DAY])
    this_round = Round.create(game_id: games(:one).id, round_number: 3, game_phase: GAME_PHASE[:NIGHT])
    Round.create(game_id: games(:one).id, round_number: 4, game_phase: GAME_PHASE[:DAY])
    result = RoundService.get_previous_round(Game.find(games(:one).id))
    assert_equal this_round.id, result.id
    assert_equal 3, result.round_number
  end
  test "nil round when no previous round" do
    Round.create(game_id: games(:one).id, round_number: 1, game_phase: GAME_PHASE[:NIGHT])
    result = RoundService.get_previous_round(Game.find(games(:one).id))
    assert_nil result
  end
  test "find action for player" do
    this_round = Round.create(game_id: games(:one).id, round_number: 1, game_phase: GAME_PHASE[:DAY])
    PlayerAction.create(target_id: players(:two).id, player_id: players(:one).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:two).id, player_id: players(:two).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:three).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:four).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:five).id, round_id: this_round.id)
    result = RoundService.find_action_for_player(this_round, players(:two))
    assert_equal players(:two).id, result.player_id
  end
  test "find action for player who has not acted" do
    this_round = Round.create(game_id: games(:one).id, round_number: 1, game_phase: GAME_PHASE[:DAY])
    PlayerAction.create(target_id: players(:two).id, player_id: players(:one).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:two).id, player_id: players(:two).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:three).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:four).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:five).id, round_id: this_round.id)
    result = RoundService.find_action_for_player(this_round, players(:six))
    assert_nil result
  end
end
