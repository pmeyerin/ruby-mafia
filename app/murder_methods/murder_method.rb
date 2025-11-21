class MurderMethod
  def initialize
    super
  end
  def attack_description
    "Generic murder description"
  end
  def aftermath_description
    "Generic aftermath description"
  end
  def tags
    %w[testTag tagTwo]
  end
  def required_location_tags
    []
  end
  def barred_location_tags
    []
  end
  def required_slot_tags
    {}
  end
  def barred_slot_tags
    {}
  end
  def required_slot_types
    []
  end
  def barred_slot_types
    []
  end
end

require_dependency "machine_gun_ambush"
require_dependency "poisoned_consumable"
require_dependency "unseen_sniper"
