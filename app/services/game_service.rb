class GameService
  def self.declare_winner(game)
    if game.round.count > 0
      mafiosi = find_living_mafiosi(game)
      non_mafiosi = find_living_non_mafiosi(game)
      if mafiosi.count == 0
        FACTIONS[:VILLAGERS]
      elsif non_mafiosi.count <= mafiosi.count
        FACTIONS[:MAFIOSI]
      end
    end
  end
  def self.find_living_mafiosi(game)
    find_living_by_role(game, PLAYER_ROLE[:MAFIOSO])
  end
  def self.find_all_mafiosi(game)
    find_all_by_role(game, PLAYER_ROLE[:MAFIOSO])
  end
  def self.find_all_by_role(game, role_int)
    game.player.filter { |player| player.role == role_int }
  end
  def self.find_by_role(game, role_int)
    found = find_all_by_role(game, role_int)
    if found.count == 1
      found.first
    end
  end
  def self.find_living_by_role(game, role_int)
    find_all_by_role(game, role_int).filter { |player| player.alive }
  end
  def self.find_all_not_in_role(game, role_int)
    game.player.filter { |player| player.role != role_int }
  end
  def self.find_living_not_in_role(game, role_int)
    find_all_not_in_role(game, role_int).filter { |player| player.alive }
  end
  def self.find_all_non_mafiosi(game)
    find_all_not_in_role(game, PLAYER_ROLE[:MAFIOSO])
  end
  def self.find_living_non_mafiosi(game)
    find_all_non_mafiosi(game).filter { |player| player.alive }
  end
end
