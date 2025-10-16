class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.string :name
      t.integer :min_players
      t.integer :max_players
      t.boolean :use_detective
      t.boolean :use_doctor
      t.integer :game_phase
      t.float :mafioso_ratio

      t.timestamps
    end
  end
end