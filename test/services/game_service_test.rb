require "test_helper"

class GameServiceTest < ActiveSupport::TestCase
  test "find all mafiosi" do
    result = GameService.find_all_mafiosi(Game.find(games(:one).id))
    sorted_result = result.sort_by { |mafioso| mafioso.id }
    assert_equal 2, sorted_result.count
    assert_equal players(:three).id, sorted_result[0].id
    assert_equal players(:four).id, sorted_result[1].id
  end
  test "find living mafiosi" do
    players(:four).update(alive: false)
    result = GameService.find_living_mafiosi(Game.find(games(:one).id))
    assert_equal 1, result.count
    assert_equal players(:three).id, result[0].id
  end
  test "find all non-mafiosi" do
    result = GameService.find_all_non_mafiosi(Game.find(games(:one).id))
    sorted_result = result.sort_by { |villager| villager.id }
    assert_equal 4, sorted_result.count
    assert_equal players(:one).id, sorted_result[0].id
    assert_equal players(:two).id, sorted_result[1].id
    assert_equal players(:five).id, sorted_result[2].id
    assert_equal players(:six).id, sorted_result[3].id
  end
  test "find all non-mafiosi, including a dead one" do
    players(:six).update(alive: false)
    result = GameService.find_all_non_mafiosi(Game.find(games(:one).id))
    sorted_result = result.sort_by { |villager| villager.id }
    assert_equal 4, sorted_result.count
    assert_equal players(:one).id, sorted_result[0].id
    assert_equal players(:two).id, sorted_result[1].id
    assert_equal players(:five).id, sorted_result[2].id
    assert_equal players(:six).id, sorted_result[3].id
  end
  test "find living non-mafiosi" do
    players(:six).update(alive: false)
    result = GameService.find_living_non_mafiosi(Game.find(games(:one).id))
    sorted_result = result.sort_by { |villager| villager.id }
    assert_equal 3, sorted_result.count
    assert_equal players(:one).id, sorted_result[0].id
    assert_equal players(:two).id, sorted_result[1].id
    assert_equal players(:five).id, sorted_result[2].id
  end
  test "game not over" do
    result = GameService.declare_winner(Game.find(games(:one).id))
    assert_nil result
  end
  test "villagers win" do
    Round.create(game_id: games(:one).id, round_number: 1, game_phase: GAME_PHASE[:DAY])
    players(:three).update(alive: false)
    players(:four).update(alive: false)
    result = GameService.declare_winner(Game.find(games(:one).id))
    assert_equal FACTIONS[:VILLAGERS], result
  end
  test "mafiosi win" do
    Round.create(game_id: games(:one).id, round_number: 1, game_phase: GAME_PHASE[:DAY])
    players(:one).update(alive: false)
    players(:two).update(alive: false)
    result = GameService.declare_winner(Game.find(games(:one).id))
    assert_equal FACTIONS[:MAFIOSI], result
  end
end
