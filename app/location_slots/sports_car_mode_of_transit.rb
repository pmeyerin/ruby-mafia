class SportsCarModeOfTransit < LocationSlot
  def initialize(seed)
    @seed = seed + "sports_car"
  end
  def description(location, slot, victim)
    "drives a sleek sports car through #{location.class.short_name}"
  end
  def self.short_name
    "sports car"
  end
  def self.slot_type
    SLOT_TYPES[:MODE_OF_TRANSIT]
  end
  def self.tags
    [ TAGS[:AUTOMOBILE] ]
  end
end
