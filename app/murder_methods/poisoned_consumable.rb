class PoisonedConsumable < MurderMethod
  def description
    "Poison in a consumable"
  end

  def attack_description(location, slots, victim)
    "as #{FormatService.format_player_name(victim)} satisfiedly put down their #{slots[SLOT_TYPES[:ACTIVITY]].short_name} \
they were struck by a sudden burning sensation in their torso. Their heart raced and breath became shallow. Their \
limbs began to shake uncontrollably and they fell to the ground. #{StringService.capitalize_first_char(witness_reaction_description(slots[SLOT_TYPES[:WITNESSES]], victim))} \
Foam began to form around #{FormatService.format_player_name(victim)}'s mouth, and their eyes turned bloodshot"
  end
  def aftermath_description(location, slots, victim)
    "the shaking in #{FormatService.format_player_name(victim)}'s limbs finally stopped. They lie unmoving on the ground, still as death"
  end
  def witness_reaction_description(witness, victim)
    if MatchService.match_any_tag(witness.class.tags, [ TAGS[:SMALL_GROUP] ])
      "One person rushed to #{FormatService.format_player_name(victim)} to provide aid while others went for help."
    elsif MatchService.match_any_tag(witness.class.tags, [ TAGS[:SOLO] ])
      "#{witness.class.short_name} tried to provide aid and shouted for help."
    end
  end
  def tags
    [ TAGS[:POISON] ]
  end

  def required_location_tags
    [ TAGS[:CONSUMABLE] ]
  end
end
