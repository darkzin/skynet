class AddInputDataAndModelPaperToCriterions < ActiveRecord::Migration
  def change
    add_column :criterions, :input_data, :text
    add_column :criterions, :model_paper, :text
  end
end
