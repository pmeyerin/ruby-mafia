class TeaActivity < LocationSlot
  def initialize(seed)
    @seed = seed + "tea"
  end
  def short_name
    "tea"
  end
  def description(location, slots, victim)
    "took a deep comforting sip of tea. They felt their mind calming as the warmth of the beverage spread throughout \
their body. #{witness_conversation(slots[SLOT_TYPES[:WITNESSES]], victim)}"
  end
  def witness_conversation(witnesses, victim)
    if MatchService.match_any_tag(witnesses.class.tags, [ TAGS[:NO_WITNESSES] ])
      "#{FormatService.format_player_name(victim)} lost themselves in thought enjoying a relaxing end to the day"
    elsif MatchService.match_any_tag(witnesses.class.tags, [ TAGS[:SOLO] ])
      "#{FormatService.format_player_name(victim)} and #{witnesses.class.short_name} fell into a lively discussion over tea"
    elsif MatchService.match_any_tag(witnesses.class.tags, [ TAGS[:SMALL_GROUP] ])
      "Everyone took a cup with a friendly toast before breaking into conversation over the day's events"
    end
  end
  def preparation_description(location, slots, victim)
    "They put the tea kettle over the fire and mixed leaves and seasonings in an infuser. The kettle whistled and #{FormatService.format_player_name(victim)} \
poured #{cup_count(location, slots[SLOT_TYPES[:WITNESSES]], victim)} filling the home with a comforting aroma#{weather_contrast(slots[SLOT_TYPES[:WEATHER]])}"
  end
  def weather_contrast(weather)
    if MatchService.match_any_tag(weather.class.tags, [ TAGS[:RAIN] ])
      " contrasting with the wet weather outside"
    end
  end
  def cup_count(location, witnesses, victim)
    if MatchService.match_any_tag(witnesses.class.tags, [ TAGS[:NO_WITNESSES] ])
      "a cup"
    elsif MatchService.match_any_tag(witnesses.class.tags, [ TAGS[:SOLO] ])
      "two cups to share with #{witnesses.class.short_name}"
    else
      "enough cups for everyone"
    end
  end
  def self.tags
    [ TAGS[:CONSUMABLE] ]
  end
  def self.required_tags
    [ TAGS[:CONSUMABLE] ]
  end
  def self.barred_tags
    []
  end
  def self.slot_type
    SLOT_TYPES[:ACTIVITY]
  end
end
