class CreateRounds < ActiveRecord::Migration[8.0]
  def change
    create_table :rounds do |t|
      t.timestamps
      t.references :game
      t.integer :game_phase
      t.integer :round_number
    end
  end
end
