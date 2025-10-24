class PlayerAction < ApplicationRecord
  belongs_to :player
  belongs_to :round
  belongs_to :target, class_name: "Player", foreign_key: :target_id
end
