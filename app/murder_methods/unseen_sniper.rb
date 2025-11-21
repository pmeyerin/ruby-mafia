class UnseenSniper < MurderMethod
  def description
    "unseen sniper"
  end

  def attack_description(location, slots, victim, seed)
    "without warning #{FormatService.format_player_name(victim)}'s neck exploded, spraying hot blood throughout the \
#{location.class.short_name}. The distant report of a single gunshot registered a split second later"
  end
  def aftermath_description(location, slots, victim, seed)
    if MatchService.match_any_tag(slots[SLOT_TYPES[:MODE_OF_TRANSIT]].class.tags, [ TAGS[:AUTOMOBILE] ])
      "a single bullet hole could be seen through the windshield. #{aftermath_rain_auto_interaction(slots[SLOT_TYPES[:WEATHER]].class.tags)}"
    elsif MatchService.contains_no_barred_tags(slots[SLOT_TYPES[:MODE_OF_TRANSIT]].class.tags, [ TAGS[:AUTOMOBILE] ]) and
      MatchService.match_any_tag(location.class.tags, [ TAGS[:INDOORS] ])
      "a single bullet hole could be seen through the window. #{aftermath_rain_indoors_interaction(slots[SLOT_TYPES[:WEATHER]])}"
    else
      "a heavy stillness settles over the scene"
    end
  end
  def aftermath_rain_indoors_interaction(weather_tags)
    if MatchService.match_any_tag(weather_tags, [ TAGS[:RAIN] ])
      "Already the rain dripping through it left a small puddle on the windowsill"
    end
  end
  def aftermath_rain_auto_interaction(weather_tags)
    if MatchService.match_any_tag(weather_tags, [ TAGS[:RAIN] ])
      "Already the rain dripping through it left a small puddle on the dashboard"
    end
  end
  def tags
    [ TAGS[:FIREARM], TAGS[:RANGE] ]
  end
end
