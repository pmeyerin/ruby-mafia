class FogWeather < LocationSlot
  def initialize(seed)
    @seed = seed
  end
  def description(location, slots, victim)
    "a heavy fog lingered over the #{location.class.short_name} thick as stew"
  end
  def self.short_name
    "foggy weather"
  end
  def self.slot_type
    SLOT_TYPES[:WEATHER]
  end
  def self.tags
    [ TAGS[:BAD_VISIBILITY] ]
  end
end
