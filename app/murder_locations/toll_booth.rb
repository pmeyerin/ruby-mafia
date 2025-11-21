class TollBooth < MurderLocation
  def description(round_number)
    victim = RoundService.find_mafia_target(@game.round.find { |round| round.round_number == round_number })
    "#{FormatService.format_player_name(victim)} pulled up to the to toll booth in their #{@slots[SLOT_TYPES[:MODE_OF_TRANSIT]].class.short_name}, \
rifling through the glove box for change. #{weather_description} they could make out that #{@slots[SLOT_TYPES[:WITNESSES]].class.short_name}. \
The smiling attendant took their change. #{@murder_method.attack_description(self, slot_hashes, victim, @seed+"attack")}. The \
attendant stood up, the smile on their face replaced by #{FormatService.format_player_name(victim)}'s ichor#{rain_and_blood}. \
#{@murder_method.aftermath_description(self, slot_hashes, victim, @seed+"aftermath")}"
  end
  def rain_and_blood
    if MatchService.match_any_tag(@slots[SLOT_TYPES[:WEATHER]].class.tags, [ TAGS[:RAIN] ])
      ", already being washed off by the driving rain"
    else
      ""
    end
  end
  def weather_description
    if MatchService.match_any_tag(@slots[SLOT_TYPES[:WEATHER]].class.tags, [ TAGS[:GOOD_VISIBILITY] ])
      "Through the clear weather"
    elsif MatchService.match_any_tag(@slots[SLOT_TYPES[:WEATHER]].class.tags, [ TAGS[:BAD_VISIBILITY] ])
      "Through the #{@slots[SLOT_TYPES[:WEATHER]].class.short_name}"
    else
      "As they looked around"
    end
  end
  def self.slot_types
    [ SLOT_TYPES[:MODE_OF_TRANSIT], SLOT_TYPES[:WITNESSES], SLOT_TYPES[:WEATHER] ]
  end
  def self.tags
    [ TAGS[:PUBLIC], TAGS[:IN_TRANSIT], TAGS[:OUTDOORS] ]
  end
  def self.short_name
    "toll booth"
  end
  def self.required_slot_tags
    { SLOT_TYPES[:MODE_OF_TRANSIT] => [ TAGS[:AUTOMOBILE] ] }
  end
end
