class SuspiciouslyEmptyTransitWitnesses < LocationSlot
  def initialize(seed)
    @seed = seed + "suspiciously_empty_transit"
  end
  def description(location, slots, victim)
    "what should be a busy roadway at #{location.class.short_name} was empty. Hairs on the back of \
#{FormatService.format_player_name(victim)}'s neck stood on end, but it was too late to turn back"
  end
  def self.short_name
    "a suspiciously empty area"
  end
  def self.slot_type
    SLOT_TYPES[:WITNESSES]
  end
  def self.tags
    [ TAGS[:NO_WITNESSES], TAGS[:PUBLIC], TAGS[:CROWDED], TAGS[:IN_TRANSIT] ]
  end
end
