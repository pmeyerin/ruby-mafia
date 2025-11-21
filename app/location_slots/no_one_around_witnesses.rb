class NoOneAroundWitnesses < LocationSlot
  def initialize(seed)
    @seed = seed + "no_one"
  end
  def description(location, slots, victim)
    "#{FormatService.format_player_name(victim)} enjoys the peace and solitude of being alone"
  end
  def self.short_name
    "a milling crowd"
  end
  def self.slot_type
    SLOT_TYPES[:WITNESSES]
  end
  def self.tags
    [ TAGS[:NO_WITNESSES] ]
  end
end
