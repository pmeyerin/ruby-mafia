class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.timestamps
      t.string :display_name
      t.references :game
      t.references :user
      t.references :action_target, foreign_key: { to_table: :players }
      t.references :prev_action_target, foreign_key: { to_table: :players }
      t.integer :role
      t.boolean :alive
    end
  end
end
