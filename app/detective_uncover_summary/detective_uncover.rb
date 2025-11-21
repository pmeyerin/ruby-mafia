class DetectiveUncover
  def initialize
    super
  end
  def description(mafioso)
    "Generic murder description"
  end
  def tags
    []
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

require_dependency "generic_detective_uncover"
