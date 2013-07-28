class AddResultToAssignment < ActiveRecord::Migration
  def change
    add_column :assignments, :result, :text
  end
end
