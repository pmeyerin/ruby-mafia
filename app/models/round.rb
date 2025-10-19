class Round < ApplicationRecord
  belongs_to :game
  has_many :player_actions
end
