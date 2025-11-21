class WalkingModeOfTransit < LocationSlot
  def initialize(seed)
  @seed = seed + "walking"
end
  def description(location, slots, victim)
    "walks casually through the #{location.class.short_name}"
  end
  def self.short_name
    "a walk"
  end
  def self.slot_type
    SLOT_TYPES[:MODE_OF_TRANSIT]
  end
  def self.tags
    [ TAGS[:PEDESTRIAN] ]
  end
end
