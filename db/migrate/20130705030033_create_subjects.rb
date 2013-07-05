class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.string :title
      t.text :about
      t.integer :order
      t.belongs_to :course, index: true

      t.timestamps
    end
  end
end
