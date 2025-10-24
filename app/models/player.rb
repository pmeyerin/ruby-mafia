class Player < ApplicationRecord
  belongs_to :game
  belongs_to :user
  has_many :player_action
  has_many :targeting_players, class_name: "PlayerAction", foreign_key: :target_id
  ROLES = %w[Villager Mafioso Detective Doctor]
end
