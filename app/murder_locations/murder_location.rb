require "json"

class MurderLocation
  @tags = %w[testTag tagTwo]
  @name = "GenericMurderLocation"

  def initialize(murder_method, game, slots, seed)
    @murder_method = murder_method
    @game = game
    @slots = slots
    @seed = seed
  end

  def slot_hashes
    @slots
  end

  def description
    "#{name} description"
  end

  def self.slot_types
    %w["generic"]
  end
  def self.required_slot_tags
    {}
  end
  def self.barred_slot_tags
    {}
  end
end

require_dependency "toll_booth"
require_dependency "victim_home"
require_dependency "village_square"
