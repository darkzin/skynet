class AddCompileCommandToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :compile_command, :string
  end
end
