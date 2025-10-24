class DetectiveInvestigationsCount < ActiveRecord::Migration[8.1]
  def change
    change_table :games do |t|
      t.integer :remaining_detective_investigations
    end
  end
end
