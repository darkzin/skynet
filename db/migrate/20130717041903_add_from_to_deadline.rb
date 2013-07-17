class AddFromToDeadline < ActiveRecord::Migration
  def change
    rename_column :deadlines, :term, :from
    add_column :deadlines, :to, :dateTime

  end
end
