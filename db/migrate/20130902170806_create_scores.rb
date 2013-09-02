class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.references :criterion, index: true
      t.integer :score
      t.references :assignment, index: true

      t.timestamps
    end
  end
end
