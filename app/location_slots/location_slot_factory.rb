class LocationSlotFactory
  def self.pick_location_slot(slot_type, method_required_tags = [], method_barred_tags = [], location_required_tags = [], location_barred_tags = [], seed)
    seed = seed + "slots"

    avail_slots = LocationSlot.subclasses.filter { |slot| slot.slot_type == slot_type and
      MatchService.contains_all_required_tags(slot.tags, method_required_tags) and
      MatchService.contains_no_barred_tags(slot.tags, method_barred_tags) and
      MatchService.contains_all_required_tags(slot.tags, location_required_tags) and
      MatchService.contains_no_barred_tags(slot.tags, location_barred_tags) }

    avail_slots[StringService.hash_string(seed) % avail_slots.length]
  end
  def self.find_tag_by_name(tag_name)
    LocationSlot.subclasses.find { |slot| slot.name == tag_name }
  end
  def list_location_slots
    LocationSlot.subclasses.map { |slot| slot.new.name }
  end
end
