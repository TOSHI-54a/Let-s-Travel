class RenameEndBudgetAndAddBudgetToBoards < ActiveRecord::Migration[7.0]
  def change
    rename_column :boards, :end_budget, :end_duration
    change_column :boards, :end_duration, :datetime
    add_column :boards, :budget, :integer
  end
end
