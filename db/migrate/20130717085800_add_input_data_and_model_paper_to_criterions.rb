class AddInputDataAndModelPaperToCriterions < ActiveRecord::Migration
  def change
    add_column :problems, :input_data, :text
    add_column :problems, :model_paper, :text
  end
end
