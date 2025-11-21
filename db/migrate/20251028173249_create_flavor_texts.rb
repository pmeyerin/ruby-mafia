class CreateFlavorTexts < ActiveRecord::Migration[8.1]
  def change
    change_table :rounds do |t|
      t.string :flavor_text_seed
    end
  end
end
