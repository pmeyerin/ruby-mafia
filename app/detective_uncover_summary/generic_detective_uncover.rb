class GenericDetectiveUncover < DetectiveUncover
  def initialize(seed)
    @seed = seed
  end
  def description(mafioso)
    "The detective uncovered that #{FormatService.format_player_name(mafioso)} was a mafioso and took them into custody. \
They have been eliminated from the game."
  end
end
