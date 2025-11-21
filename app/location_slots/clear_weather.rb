class ClearWeather < LocationSlot
  def initialize(seed)
    @seed = seed
  end
  def description(location, slots, victim)
    "the weather was calm and clear"
  end
  def self.short_name
    "clear weather"
  end
  def self.slot_type
    SLOT_TYPES[:WEATHER]
  end
  def self.tags
    [ TAGS[:GOOD_VISIBILITY], TAGS[:CALM] ]
  end
end
