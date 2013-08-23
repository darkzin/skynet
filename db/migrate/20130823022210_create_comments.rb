class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :content
      t.references :professor, index: true
      t.references :assignment, index: true

      t.timestamps
    end
  end
end
