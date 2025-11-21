require "test_helper"

class MurderLocationFactoryTest < ActiveSupport::TestCase
  test "pick returns something" do
    this_game = games(:one)
    this_round = Round.create(game_id: this_game.id, game_phase: GAME_PHASE[:NIGHT], round_number: 1, flavor_text_seed: "blah")
    result = MurderLocationFactory.pick_murder_location(MachineGunAmbush.new, this_round)
    assert_equal TollBooth, result.class # if new murder locations are added this will have to change
  end
  test "find specific method" do
    result = MurderLocationFactory.find_murder_location("TollBooth")
    assert_equal TollBooth, result
  end
  test "find method not found" do
    assert_nil MurderLocationFactory.find_murder_location("NotALocation")
  end
end
