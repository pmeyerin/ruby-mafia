class ThunderStormWeather < LocationSlot
  def initialize(seed)
    @seed = seed
  end
  def description(location, slots, victim)
    "the dark of night was briefly lit by the flash of lighting. A moment later the sound of the driving rain was drowned out by the crash of thunder"
  end
  def self.short_name
    "thunder storm"
  end
  def self.slot_type
    SLOT_TYPES[:WEATHER]
  end
  def self.tags
    [ TAGS[:RAIN], TAGS[:THUNDER] ]
  end
end
