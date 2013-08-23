class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :compile_command
      t.references :course, index: true

      t.timestamps
    end
  end
end
