require "test_helper"

class MurderMethodFactoryTest < ActiveSupport::TestCase
  test "pick returns something" do
    test_round = Round.create(game_id: games(:one).id, game_phase: GAME_PHASE[:NIGHT], round_number: 1, flavor_text_seed: "blah")
    result = MurderMethodFactory.pick_murder_method(test_round)
    assert_equal PoisonedConsumable, result.class # if new murder methods are added this will have to change
  end
  test "find specific method" do
    result = MurderMethodFactory.find_murder_method("MachineGunAmbush")
    assert_equal MachineGunAmbush, result
  end
  test "find method not found" do
    assert_nil MurderMethodFactory.find_murder_method("NotAMethod")
  end
end
