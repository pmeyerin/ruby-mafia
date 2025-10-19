class CreatePlayerActions < ActiveRecord::Migration[8.0]
  def change
    create_table :player_actions do |t|
      t.timestamps
      t.references :player
      t.references :round
      t.references :target
    end
  end
end
