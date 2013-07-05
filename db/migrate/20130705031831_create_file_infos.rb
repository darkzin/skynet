class CreateFileInfos < ActiveRecord::Migration
  def change
    create_table :file_infos do |t|
      t.string :name
      t.string :path
      t.string :extension
      t.belongs_to :category, polymorphic: true, index: true

      t.timestamps
    end
  end
end
