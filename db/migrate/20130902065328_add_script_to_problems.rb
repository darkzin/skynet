class AddScriptToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :script, :string
  end
end
