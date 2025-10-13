class Player < ApplicationRecord
  belongs_to :game
  belongs_to :user
  ROLES = %w[Villager Mafioso Detective Doctor]
end
