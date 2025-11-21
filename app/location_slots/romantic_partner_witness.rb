class RomanticPartnerWitness < LocationSlot
  def initialize(seed)
    @seed = seed + "romantic-partner"
  end
  def description(location, slots, victim)
    formatted_victim_name = FormatService.format_player_name(victim)
    avail_descriptions = [
      "a dashingly handsome man in a dark suit. He placed a possessive hand on the small of #{formatted_victim_name}'s \
back",
      "a stunning woman in a long dress, her arms wrapped around #{formatted_victim_name}'s nearest arm",
      "a beautiful younger man, slim and taut. He looked up lovingly at #{formatted_victim_name}",
      "a striking woman, tall and broad. She placed a possessive hand on the small of #{formatted_victim_name}'s back",
      "an androgynous head-turner, fashionable and casual, laughing with #{formatted_victim_name}"
    ]
    "their romantic partner, #{avail_descriptions[StringService.hash_string(@seed) % avail_descriptions.length]}"
  end
  def self.short_name
    "their intimate partner"
  end
  def self.slot_type
    SLOT_TYPES[:WITNESSES]
  end
  def self.tags
    [ TAGS[:SOLO] ]
  end
end
