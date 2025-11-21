class DetectiveUncoverFactory
  def self.pick_uncovery_type(round)
    DetectiveUncover.subclasses[StringService.hash_string(round.flavor_text_seed) % DetectiveUncover.subclasses.length].new(round.flavor_text_seed + "detective")
  end
end
