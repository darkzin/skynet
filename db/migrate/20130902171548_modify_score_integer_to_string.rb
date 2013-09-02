class ModifyScoreIntegerToString < ActiveRecord::Migration
  def change
    change_column :scores, :score, :string
  end
end
