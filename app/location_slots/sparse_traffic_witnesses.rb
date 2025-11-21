class SparseTrafficWitnesses < LocationSlot
  def initialize(seed)
    @seed = seed + "sparse_traffic"
  end
  def description(location, slots, victim)
    "the traffic was light. A few cars shared the road with #{FormatService.format_player_name(victim)} and small groups \
of pedestrians moved along the sides of the road"
  end
  def self.short_name
    "sparse traffic"
  end
  def self.slot_type
    SLOT_TYPES[:WITNESSES]
  end
  def self.tags
    [ TAGS[:TRANSIT], TAGS[:PUBLIC] ]
  end
end
