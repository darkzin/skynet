class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.text :about
      t.references :professor, index: true

      t.timestamps
    end
  end
end
