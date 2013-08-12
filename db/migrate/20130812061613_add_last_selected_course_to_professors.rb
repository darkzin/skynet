class AddLastSelectedCourseToProfessors < ActiveRecord::Migration
  def change
    add_column :professors, :last_selected_course, :integer
  end
end
