class RenameDeadlinesDateColumn < ActiveRecord::Migration
  def change
    rename_column :deadlines, :from, :start
    rename_column :deadlines, :to, :end
  end
end
