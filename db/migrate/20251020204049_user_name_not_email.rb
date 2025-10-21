class UserNameNotEmail < ActiveRecord::Migration[8.0]
  def change
    change_table :users do |t|
      t.change_null :email_address, true, index: { unique: true }
      t.string :user_name, null: false
    end
  end
end
