class MurderLocationFactory
  def self.pick_murder_location(murder_method, round)
    seed = round.flavor_text_seed

    possible_locations = MurderLocation.subclasses.filter { |location|
      MatchService.contains_all_required_slot_types(location, murder_method) and
      MatchService.contains_no_barred_slot_types(location, murder_method) and
      MatchService.contains_all_required_tags(location.tags, murder_method.required_location_tags) and
      MatchService.contains_no_barred_tags(location.tags, murder_method.barred_location_tags) }

    chosen_loc = possible_locations[StringService.hash_string(seed) % possible_locations.length]

    slots = {}
    chosen_loc.slot_types.each do  |slot_type|
      slots[slot_type] = LocationSlotFactory.pick_location_slot(
        slot_type, murder_method.required_slot_tags[slot_type],
        murder_method.barred_slot_tags[slot_type],
        chosen_loc.required_slot_tags[slot_type],
        chosen_loc.barred_slot_tags[slot_type],
        seed).new(seed)
    end

    chosen_loc.new(murder_method, round.game, slots, seed)
  end
  def self.find_murder_location(location_name)
    location = MurderLocation.subclasses.find { |location| location.name == location_name }
    if location
      location
    end
  end
end
