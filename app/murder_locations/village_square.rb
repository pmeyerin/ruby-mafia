class VillageSquare < MurderLocation
  def description(round_number)
    victim = RoundService.find_mafia_target(@game.round.find { |round| round.round_number == round_number })
    "#{StringService.capitalize_first_char(@slots[SLOT_TYPES[:WEATHER]].description(self, slot_hashes, victim))} as \
#{FormatService.format_player_name(victim)} #{@slots[SLOT_TYPES[:MODE_OF_TRANSIT]].description(self, slot_hashes, victim)}. \
#{StringService.capitalize_first_char(@slots[SLOT_TYPES[:WITNESSES]].description(self, slot_hashes, victim))}. \
#{StringService.capitalize_first_char(@murder_method.attack_description(self, slot_hashes, victim, @seed + "murder"))}. \
#{witness_reaction(@slots[SLOT_TYPES[:WITNESSES]], victim)}#{StringService.capitalize_first_char(@murder_method.aftermath_description(self, slot_hashes, victim, @seed + "aftermath"))}."
  end
  def witness_reaction(witnesses, victim)
    if MatchService.match_any_tag(witnesses.class.tags, [ TAGS[:NO_WITNESSES] ])
      ""
    elsif MatchService.match_any_tag(witnesses.class.tags, [ TAGS[:CROWDED] ])
      "The crowd goes into a panic. "
    elsif MatchService.match_any_tag(witnesses.class.tags, [ TAGS[:ACCOMPANIED_IN_CROWD] ])
      "#{StringService.capitalize_first_char(witnesses.short_name)} rushes to #{FormatService.format_player_name(victim)} \
as the crowd goes into a panic. "
    end
  end
  def self.slot_types
    [ SLOT_TYPES[:WITNESSES], SLOT_TYPES[:WEATHER], SLOT_TYPES[:MODE_OF_TRANSIT] ]
  end
  def self.tags
    [ TAGS[:CROWDED], TAGS[:PUBLIC], TAGS[:OUTDOORS], TAGS[:IN_TRANSIT] ]
  end
  def self.required_slot_tags
    { SLOT_TYPES[:MODE_OF_TRANSIT] => [ TAGS[:PEDESTRIAN] ], SLOT_TYPES[:WITNESSES] => [ TAGS[:PUBLIC] ] }
  end
  def self.short_name
    "village square"
  end
end
