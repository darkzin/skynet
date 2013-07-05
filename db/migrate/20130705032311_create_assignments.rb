class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.string :state
      t.text :compile_message
      t.integer :lead_time
      t.integer :memory_usage
      t.belongs_to :student, index: true
      t.belongs_to :problem, index: true

      t.timestamps
    end
  end
end
