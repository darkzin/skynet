class AddYearAndTermToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :year, :int
    add_column :courses, :term, :int
  end
end
