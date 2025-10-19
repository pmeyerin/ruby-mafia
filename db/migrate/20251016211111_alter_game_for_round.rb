class AlterGameForRound < ActiveRecord::Migration[8.0]
  def change
    change_table :games do |t|
      t.remove :game_phase
    end

    change_table :players do |t|
      t.remove_references :action_target, :prev_action_target
    end
  end
end
