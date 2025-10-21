class Player < ApplicationRecord
  belongs_to :game
  belongs_to :user
  has_many :player_action
  ROLES = %w[Villager Mafioso Detective Doctor]
end
