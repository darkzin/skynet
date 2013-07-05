class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.text :content
      t.belongs_to :professor, index: true
      t.belongs_to :course, index: true

      t.timestamps
    end
  end
end
