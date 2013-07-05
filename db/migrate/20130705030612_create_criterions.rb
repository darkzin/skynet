class CreateCriterions < ActiveRecord::Migration
  def change
    create_table :criterions do |t|
      t.string :title
      t.integer :score

      t.timestamps
    end
  end
end
