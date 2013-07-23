class AddStudentNumberToStudent < ActiveRecord::Migration
  def change
    add_column :students, :student_number, :string
  end
end
