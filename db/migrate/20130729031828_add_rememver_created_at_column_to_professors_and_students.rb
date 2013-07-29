class AddRememverCreatedAtColumnToProfessorsAndStudents < ActiveRecord::Migration
  def change
    add_column :professors, :remember_created_at, :datetime
  end
end
