class FullMoonWeather < LocationSlot
  def initialize(seed)
    @seed = seed
  end
  def description(location, slots, victim)
    "a full moon shone, lighting the night near as clear as it was day"
  end
  def self.short_name
    "clear weather"
  end
  def self.slot_type
    SLOT_TYPES[:WEATHER]
  end
  def self.tags
    [ TAGS[:GOOD_VISIBILITY] ]
  end
end
