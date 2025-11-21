class LocationSlot
  @slot_type = "generic"

  def description(location, slots, victim, seed)
    "Generic location slot description"
  end
  def self.short_name
    "GenericSlot"
  end
  def self.tags
    %w[testTag tagTwo]
  end
  def self.required_tags
    []
  end
  def self.barred_tags
    []
  end
end

require_dependency "bicycle_mode_of_transit"
require_dependency "cards_activity"
require_dependency "clear_weather"
require_dependency "coffee_activity"
require_dependency "fog_weather"
require_dependency "full_moon_weather"
require_dependency "light_rain_weather"
require_dependency "milling_crowd_witnesses"
require_dependency "no_one_around_witnesses"
require_dependency "romantic_partner_witness"
require_dependency "sparse_traffic_witnesses"
require_dependency "sports_car_mode_of_transit"
require_dependency "suspiciously_empty_transit_witnesses"
require_dependency "suspiciously_empty_witnesses"
require_dependency "tea_activity"
require_dependency "thunder_storm_weather"
require_dependency "walking_mode_of_transit"
