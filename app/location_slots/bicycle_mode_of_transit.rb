class BicycleModeOfTransit < LocationSlot
  def initialize(seed)
    @seed = seed + "bike"
  end
  def description(location, slots, victim)
    "rode on a bicycle"
  end
  def self.short_name
    "a bike"
  end
  def self.slot_type
    SLOT_TYPES[:MODE_OF_TRANSIT]
  end
  def self.tags
    [ TAGS[:PEDESTRIAN] ]
  end
end
