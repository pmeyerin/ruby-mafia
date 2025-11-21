class MillingCrowdWitnesses < LocationSlot
  def initialize(seed)
    @seed = seed + "milling_crowd"
  end
  def description(location, slots, victim)
    "the din of a dozen conversations buzzed around #{FormatService.format_player_name(victim)} as the crowed milled about \
around the #{location.class.short_name}"
  end
  def self.short_name
    "a milling crowd"
  end
  def self.slot_type
    SLOT_TYPES[:WITNESSES]
  end
  def self.tags
    [ TAGS[:PUBLIC], TAGS[:CROWDED] ]
  end
end
