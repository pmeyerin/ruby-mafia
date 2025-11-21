class LightRainWeather < LocationSlot
  def initialize(seed)
    @seed = seed
  end
  def description(location, slots, victim)
    "a light rain fell, wafting up the smell of petrichor and leaving the world damp"
  end
  def self.short_name
    "light rain"
  end
  def self.slot_type
    SLOT_TYPES[:WEATHER]
  end
  def self.tags
    [ TAGS[:RAIN] ]
  end
end
