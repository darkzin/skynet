class AddFileToFileInfos < ActiveRecord::Migration
  def change
    add_column :file_infos, :file, :string
  end
end
