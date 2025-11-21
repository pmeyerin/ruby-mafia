class DetectiveUncoverFactory
  def self.pick_uncovery_type(round)
    DetectiveUncover.subclasses.subclasses.sort_by { |clazz| clazz.name }[StringService.hash_string(round.flavor_text_seed) % DetectiveUncover.subclasses.length].new(round.flavor_text_seed + "detective")
  end
end
