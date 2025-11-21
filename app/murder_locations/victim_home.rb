class VictimHome < MurderLocation
  def description(round_number)
    victim = RoundService.find_mafia_target(@game.round.find { |round| round.round_number == round_number })
    "It had been a long day when #{FormatService.format_player_name(victim)} arrived at their home\
#{companion_arrival_text(@slots[SLOT_TYPES[:WITNESSES]], victim)}. #{@slots[SLOT_TYPES[:ACTIVITY]].preparation_description(self, slot_hashes, victim)}. \
#{FormatService.format_player_name(victim)} settled into a comfortable chair near the window and \
#{@slots[SLOT_TYPES[:ACTIVITY]].description(self, slot_hashes, victim)}. #{StringService.capitalize_first_char(@murder_method.attack_description(self, slot_hashes, victim))}. \
#{StringService.capitalize_first_char(@murder_method.aftermath_description(self, slot_hashes, victim))}."
  end
  def companion_arrival_text(witnesses, victim)
    unless MatchService.match_any_tag(witnesses.class.tags, [ TAGS[:NO_WITNESSES] ])
      " along with #{witnesses.description(self, slot_hashes, victim)}"
    end
    end
  def self.slot_types
    [ SLOT_TYPES[:WITNESSES], SLOT_TYPES[:WEATHER], SLOT_TYPES[:ACTIVITY] ]
  end
  def self.tags
    [ TAGS[:DOMESTIC], TAGS[:PRIVATE], TAGS[:INDOORS], TAGS[:CONSUMABLE] ]
  end
  def self.short_name
    "Victim's Home"
  end
  def self.barred_slot_tags
    { SLOT_TYPES[:WITNESSES] => [ TAGS[:CROWDED], TAGS[:PUBLIC] ] }
  end
end
