require "test_helper"

class VictimHomeTest < ActiveSupport::TestCase
  test "happy path" do
    this_round = Round.create(game_id: games(:one).id, round_number: 1, game_phase: GAME_PHASE[:NIGHT])
    PlayerAction.create(target_id: players(:one).id, player_id: players(:three).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:four).id, round_id: this_round.id)

    victim_home_slots = {
      SLOT_TYPES[:WEATHER] => ClearWeather.new("blah"),
      SLOT_TYPES[:WITNESSES] => RomanticPartnerWitness.new("blah"),
      SLOT_TYPES[:ACTIVITY] => TeaActivity.new("blah")
    }

    result = VictimHome.new(PoisonedConsumable.new, games(:one), victim_home_slots, "blah")
    assert_equal "It had been a long day when <span class=\"player-name\">One</span> arrived at their home along \
with their romantic partner, an androgynous head-turner, fashionable and casual, laughing with <span class=\"player-name\">One</span>. \
They put the tea kettle over the fire and mixed leaves and seasonings in an infuser. The kettle whistled and \
<span class=\"player-name\">One</span> poured two cups to share with their intimate partner filling the home with a \
comforting aroma. <span class=\"player-name\">One</span> settled into a comfortable chair near the window and took a deep \
comforting sip of tea. They felt their mind calming as the warmth of the beverage spread throughout their body. \
<span class=\"player-name\">One</span> and their intimate partner fell into a lively discussion over tea. As \
<span class=\"player-name\">One</span> satisfiedly put down their tea they were struck by a sudden burning sensation in \
their torso. Their heart raced and breath became shallow. Their limbs began to shake uncontrollably and they fell to the \
ground. Their intimate partner tried to provide aid and shouted for help. Foam began to form around <span class=\"player-name\">One</span>'s mouth, \
and their eyes turned bloodshot. The shaking in <span class=\"player-name\">One</span>'s limbs finally stopped. They lie \
unmoving on the ground, still as death.", result.description(1)
  end
  test "different intimate partner" do
    this_round = Round.create(game_id: games(:one).id, round_number: 1, game_phase: GAME_PHASE[:NIGHT])
    PlayerAction.create(target_id: players(:one).id, player_id: players(:three).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:four).id, round_id: this_round.id)

    victim_home_slots = {
      SLOT_TYPES[:WEATHER] => ClearWeather.new("blah"),
      SLOT_TYPES[:WITNESSES] => RomanticPartnerWitness.new("blah2"),
      SLOT_TYPES[:ACTIVITY] => TeaActivity.new("blah")
    }

    result = VictimHome.new(PoisonedConsumable.new, games(:one), victim_home_slots, "blah")
    assert_equal "It had been a long day when <span class=\"player-name\">One</span> arrived at their home along \
with their romantic partner, a dashingly handsome man in a dark suit. He placed a possessive hand on the small of <span class=\"player-name\">One</span>'s back. \
They put the tea kettle over the fire and mixed leaves and seasonings in an infuser. The kettle whistled and \
<span class=\"player-name\">One</span> poured two cups to share with their intimate partner filling the home with a \
comforting aroma. <span class=\"player-name\">One</span> settled into a comfortable chair near the window and took a deep \
comforting sip of tea. They felt their mind calming as the warmth of the beverage spread throughout their body. \
<span class=\"player-name\">One</span> and their intimate partner fell into a lively discussion over tea. As \
<span class=\"player-name\">One</span> satisfiedly put down their tea they were struck by a sudden burning sensation in \
their torso. Their heart raced and breath became shallow. Their limbs began to shake uncontrollably and they fell to the \
ground. Their intimate partner tried to provide aid and shouted for help. Foam began to form around <span class=\"player-name\">One</span>'s mouth, \
and their eyes turned bloodshot. The shaking in <span class=\"player-name\">One</span>'s limbs finally stopped. They lie \
unmoving on the ground, still as death.", result.description(1)
  end
end
