require "test_helper"

class TollBoothTest < ActiveSupport::TestCase
  test "happy path" do
    this_round = Round.create(game_id: games(:one).id, round_number: 1, game_phase: GAME_PHASE[:NIGHT])
    PlayerAction.create(target_id: players(:one).id, player_id: players(:three).id, round_id: this_round.id)
    PlayerAction.create(target_id: players(:one).id, player_id: players(:four).id, round_id: this_round.id)

    toll_booth_slots = {
      SLOT_TYPES[:WEATHER] => ClearWeather.new("blah"),
      SLOT_TYPES[:WITNESSES] => SparseTrafficWitnesses.new("blah"),
      SLOT_TYPES[:MODE_OF_TRANSIT] => SportsCarModeOfTransit.new("blah")
    }

    result = TollBooth.new(MachineGunAmbush.new, games(:one), toll_booth_slots, "blah")
    assert_equal "<span class=\"player-name\">One</span> pulled up to the to toll booth in their sports car, rifling \
through the glove box for change. Through the clear weather they could make out that sparse traffic. The smiling \
attendant took their change. Suddenly there came a shout. Onlookers eyes went wide looking behind <span class=\"player-name\">\
One</span>. <span class=\"player-name\">One</span> turned their head to see a mysterious figure emerge from hiding, \
in their hands the unmistakable outline of a Thompson. <span class=\"player-name\">One</span> moved to flee the scene \
as the crackle of machine gun fire rang out. The attendant stood up, the smile on their face replaced by \
<span class=\"player-name\">One</span>'s ichor. The sound of gunfire fell silent, replaced by the clinking of shell \
casings as they fell to the ground and rolled forward, reaching the slick pools of <span class=\"player-name\">One</span>'s \
blood. The mysterious figure approached <span class=\"player-name\">One</span>'s supine form, their identity still \
clouded as <span class=\"player-name\">One</span>'s vision darkened and finally went out entirely.", result.description(1)
  end
end
