class AddProblemIdToCriterions < ActiveRecord::Migration
  def change
    add_column :criterions, :problem_id, :integer, references: :problems
    add_index :criterions, :problem_id
  end
end
