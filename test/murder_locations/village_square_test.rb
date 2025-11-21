require "test_helper"

class VillageSquareTest < ActiveSupport::TestCase
  test "happy path" do
    this_round = Round.create(game_id: games(:one).id, round_number: 1, game_phase: GAME_PHASE[:NIGHT])
    PlayerAction.create(target_id: players(:one).id, player_id: players(:three).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:four).id, round_id: this_round.id)

    location_slots = {
      SLOT_TYPES[:WEATHER] => ClearWeather.new("blah"),
      SLOT_TYPES[:WITNESSES] => MillingCrowdWitnesses.new("blah"),
      SLOT_TYPES[:MODE_OF_TRANSIT] => WalkingModeOfTransit.new("blah")
    }

    result = VillageSquare.new(UnseenSniper.new, games(:one), location_slots, "blah")
    assert_equal "The weather was calm and clear as <span class=\"player-name\">One</span> walks casually through the village square. \
The din of a dozen conversations buzzed around <span class=\"player-name\">One</span> as the crowed milled about around \
the village square. Without warning <span class=\"player-name\">One</span>'s neck exploded, spraying hot blood throughout \
the village square. The distant report of a single gunshot registered a split second later. The crowd goes into a panic. \
A heavy stillness settles over the scene.", result.description(1)
  end
  test "unwitnessed" do
    this_round = Round.create(game_id: games(:one).id, round_number: 1, game_phase: GAME_PHASE[:NIGHT])
    PlayerAction.create(target_id: players(:one).id, player_id: players(:three).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:four).id, round_id: this_round.id)

    location_slots = {
      SLOT_TYPES[:WEATHER] => LightRainWeather.new("blah"),
      SLOT_TYPES[:WITNESSES] => NoOneAroundWitnesses.new("blah"),
      SLOT_TYPES[:MODE_OF_TRANSIT] => WalkingModeOfTransit.new("blah")
    }

    result = VillageSquare.new(UnseenSniper.new, games(:one), location_slots, "blah")
    assert_equal "A light rain fell, wafting up the smell of petrichor and leaving the world damp as \
<span class=\"player-name\">One</span> walks casually through the village square. \
<span class=\"player-name\">One</span> enjoys the peace and solitude of being alone. Without warning \
<span class=\"player-name\">One</span>'s neck exploded, spraying hot blood throughout the village square. The distant \
report of a single gunshot registered a split second later. A heavy stillness settles over the scene.", result.description(1)
  end
end
