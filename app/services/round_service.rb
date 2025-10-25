class RoundService
  def self.find_mafia_target(round)
    if round.game_phase == GAME_PHASE[:NIGHT]
      mafia_actions = round.player_actions.filter { |action| action.player.role == PLAYER_ROLE[:MAFIOSO] }
      if mafia_actions.count > 0
        target = mafia_actions[0]
        if mafia_actions.filter { |action| action.target_id != target.target_id }.count == 0
          target.target
        end
      end
    end
  end

  def self.doctor_saved(round)
    if round.game_phase == GAME_PHASE[:NIGHT]
      mafia_target = find_mafia_target(round)
      doctor_target = singular_target_by_role(round, PLAYER_ROLE[:DOCTOR])
      if mafia_target and doctor_target
        return mafia_target.id == doctor_target.id
      end
    end
    false
  end

  def self.singular_target_by_role(round, role_int)
    actions = round.player_actions.filter { |action| action.player.role == role_int }
      if actions.count > 0
        actions[0].target
      end
  end

  def self.detective_found(round)
    singular_target_by_role(round, PLAYER_ROLE[:DETECTIVE])
  end

  def self.find_eliminated_player(round)
    if round.game_phase == GAME_PHASE[:DAY]
      raw_votes = round.player_actions
      tallied_votes = {}

      raw_votes.each do |vote|
        voted_player = vote.target
        if tallied_votes[voted_player]
          tallied_votes[voted_player] = tallied_votes[voted_player] + 1
        else
          tallied_votes[voted_player] = 1
        end
      end

      at_least_half = Array.new
      tallied_votes.each do |player, votes|
        if votes >= raw_votes.count / 2.0
          at_least_half << player
        end
      end

      if at_least_half.count == 1
        at_least_half[0]
      end
    end
  end

  def self.load_current_round
    Round.where(game_id: @game.id, round_number: Round.where(game_id: @game.id).maximum(:round_number)).first
  end

  def self.get_current_round(game)
    if game.round.count > 0
      sorted = game.round.sort_by { |round| round.round_number }
      sorted.reverse[0]
    end
  end

  def self.get_previous_round(game)
    if game.round.count > 1
      sorted = game.round.sort_by { |round| round.round_number }
      sorted.reverse[1]
    end
  end
  def self.targeting_this_player(round, player)
    round.player_actions.filter { |action| action.target_id == player.id }.map { |action| action.player }
  end

  def self.find_action_for_player(round, player)
    actions = round.player_actions.filter { |action| action.player_id == player.id }
    if actions.count == 1
      actions[0]
    end
  end
end
