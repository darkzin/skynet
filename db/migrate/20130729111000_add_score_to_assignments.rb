class AddScoreToAssignments < ActiveRecord::Migration
  def change
    add_column :assignments, :score, :integer
  end
end
