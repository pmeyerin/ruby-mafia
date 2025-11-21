class MatchService
  # ampersand operator returns intersection of arrays
  def self.match_any_tag(item_tags, match_tags = [])
    if match_tags == nil
      match_tags = []
    end
    not (item_tags & match_tags).empty?
  end
  def self.match_all_tags(item_tags, match_tags = [])
    if match_tags == nil or match_tags.empty?
      return true
    end
    (item_tags & match_tags).count == match_tags.count
  end
  def self.contains_all_required_tags(item_tags, required_tags = [])
    match_all_tags(item_tags, required_tags)
  end
  def self.contains_no_barred_tags(item_tags, barred_tags = [])
    not match_any_tag(item_tags, barred_tags)
  end
  def self.contains_all_required_slot_types(location, murder_method)
    if murder_method.required_slot_types.empty?
      true
    end
    (location.slot_types & murder_method.required_slot_types).count == murder_method.required_slot_types.count
  end
  def self.contains_no_barred_slot_types(location, murder_method)
    if murder_method.barred_slot_types.empty?
      true
    end
    (location.slot_types & murder_method.barred_slot_types).empty?
  end
end
