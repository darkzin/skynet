class CreateScripts < ActiveRecord::Migration
  def change
    create_table :scripts do |t|
      t.belongs_to :problem, index: true

      t.timestamps
    end
  end
end
