class GenericVotingDescription < VotingDescription
  def initialize(seed)
    @seed = seed
  end
  def description(round)
    votes_for = Hash.new
    round.player_actions.each do |action|
      unless votes_for[action.target]
        votes_for[action.target] = []
      end
      votes_for[action.target] << action.player
    end

    voted_out_name = FormatService.format_player_name(RoundService.find_eliminated_player(round))
    "The votes broke down as:<br/>#{vote_breakdown(votes_for)}<br/>resulting in #{voted_out_name} being voted out."
  end
  def vote_breakdown(votes_for)
    result = []
    votes_for.each do |target, voters|
      result << "#{FormatService.format_player_name(target)}: #{voters.map { |voter| FormatService.format_player_name(voter) }.join(", ")}"
    end
    result.join("<br/>")
  end
end
