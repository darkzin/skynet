class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :title
      t.text :about
      t.integer :order
      t.text :model_paper
      t.text :input_data
      t.belongs_to :subject, index: true

      t.timestamps
    end
  end
end
