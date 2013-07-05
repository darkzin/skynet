class CreateDeadlines < ActiveRecord::Migration
  def change
    create_table :deadlines do |t|
      t.datetime :term
      t.integer :penalty
      t.belongs_to :subject, index: true

      t.timestamps
    end
  end
end
