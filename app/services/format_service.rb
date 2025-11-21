class FormatService
  def self.format_player_name(player)
    "<span class=\"player-name\">" + player.display_name.capitalize + "</span>"
  end
end
