class MachineGunAmbush < MurderMethod
  def description
    "Machine gun ambush"
  end

  def attack_description(location, slots, victim, seed)
    "Suddenly there came a shout. #{witness_reaction_description(slots[SLOT_TYPES[:WITNESSES]].class.tags, victim)} #{FormatService.format_player_name(victim)} turned their head to see a mysterious figure emerge from hiding, in their hands the unmistakable outline of a Thompson. #{FormatService.format_player_name(victim)} moved to flee the scene as the crackle of machine gun fire #{sound_interaction(slots[SLOT_TYPES[:WEATHER]].class.tags, slots[SLOT_TYPES[:WITNESSES]].class.tags)}"
  end
  def aftermath_description(location, slots, victim, seed)
    if MatchService.match_any_tag(slots[SLOT_TYPES[:WITNESSES]].class.tags, [ TAGS[:NO_WITNESSES] ]) and StringService.hash_string(seed + "aftermath") % 5 > 2
      "As the shooting finally stopped the onlookers looked around, but the mysterious figure was already gone."
    else
      "The sound of gunfire fell silent, replaced by the clinking of shell casings as they fell to the ground and rolled forward, reaching the slick pools of #{FormatService.format_player_name(victim)}'s blood#{aftermath_rain_blood_interaction(slots[SLOT_TYPES[:WEATHER]].class.tags)}. The mysterious figure approached #{FormatService.format_player_name(victim)}'s supine form, their identity still clouded as #{FormatService.format_player_name(victim)}'s vision darkened and finally went out entirely."
    end
  end
  def aftermath_rain_blood_interaction(weather_tags)
    if MatchService.match_any_tag(weather_tags, [ TAGS[:RAIN] ])
      ", thinning out as it is carried away with the falling rain"
    else
      ""
    end
  end
  def witness_reaction_description(witness_tags, victim)
    unless MatchService.match_any_tag(witness_tags, [ TAGS[:NO_WITNESSES] ])
      "Onlookers eyes went wide looking behind #{FormatService.format_player_name(victim)}."
    end
  end
  def sound_interaction(weather_tags, witness_tags)
    if MatchService.match_any_tag(weather_tags, [ TAGS[:CALM] ]) and MatchService.match_any_tag(witness_tags, [ TAGS[:QUIET] ])
      "broke through the stillness of the evening air"
    elsif MatchService.match_any_tag(weather_tags, [ TAGS[:THUNDER] ])
      "mingled with the crash of thunder"
    else
      "rang out"
    end
  end

  def tags
    [ TAGS[:FIREARM], TAGS[:RANGE] ]
  end

  def required_location_tags
    [ TAGS[:IN_TRANSIT] ]
  end
end
