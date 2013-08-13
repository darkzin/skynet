class ChangeTitleToNameAndAboutToContent < ActiveRecord::Migration
  def change
    rename_column :subjects, :title, :name
    rename_column :problems, :title, :name
    rename_column :criterions, :title, :name
    rename_column :notices, :title, :name

    rename_column :subjects, :about, :content
    rename_column :courses, :about, :content
    rename_column :problems, :about, :content
  end
end
