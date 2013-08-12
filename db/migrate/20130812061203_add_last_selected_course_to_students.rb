class AddLastSelectedCourseToStudents < ActiveRecord::Migration
  def change
    add_column :students, :last_selected_course, :integer
  end
end
