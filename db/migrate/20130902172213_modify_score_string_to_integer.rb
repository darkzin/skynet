class ModifyScoreStringToInteger < ActiveRecord::Migration
  def change
    change_column :scores, :score, :integer
  end
end
