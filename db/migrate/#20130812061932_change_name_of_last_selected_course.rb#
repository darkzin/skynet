class ChangeNameOfLastSelectedCourse < ActiveRecord::Migration
  def change
    rename_column :students, :last_selected_course, :last_selected_course_id
    rename_column :professors, :last_selected_course, :last_selected_course_id
  end
end
