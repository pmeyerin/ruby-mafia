class VotingDescriptionFactory
  def self.pick_voting_description(round)
    VotingDescription.subclasses[StringService.hash_string(round.flavor_text_seed) % VotingDescription.subclasses.length].new(round.flavor_text_seed + "votes")
  end
end
