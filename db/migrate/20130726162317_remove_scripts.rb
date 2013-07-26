class RemoveScripts < ActiveRecord::Migration
  def change
    drop_table :scripts
    remove_column :problems, :script_id
  end
end
