class CardsActivity < LocationSlot
  def initialize(seed)
    @seed = seed + "cards"
  end
  def short_name
    "cards"
  end
  def description(location, slots, victim)
    witnesses = slots[SLOT_TYPES[:WITNESSES]]
    if MatchService.match_any_tag(witnesses.class.tags, [ TAGS[:NO_WITNESSES] ])
      "#{FormatService.format_player_name(victim)} laid out cards in front of them and settled in for a game of solitaire"
    elsif MatchService.match_any_tag(witnesses.class.tags, [ TAGS[:SOLO] ])
      "#{FormatService.format_player_name(victim)} dealt out cards to #{witnesses.class.short_name} and themself and they fell into their game"
    elsif MatchService.match_any_tag(witnesses.class.tags, [ TAGS[:SMALL_GROUP] ])
      "#{FormatService.format_player_name(victim)} dealt out cards to everyone as the others joked and readied their bets"
    end
  end
  def preparation_description(location, slots, victim)
    "#{FormatService.format_player_name(victim)} produced a deck of cards and began idly shuffling them"
  end
  def weather_contrast(weather)
    if MatchService.match_any_tag(weather.class.tags, [ TAGS[:RAIN] ])
      " contrasting with the wet weather outside"
    end
  end
  def self.tags
    [ TAGS[:GAMING] ]
  end
  def self.barred_tags
    []
  end
  def self.slot_type
    SLOT_TYPES[:ACTIVITY]
  end
end
