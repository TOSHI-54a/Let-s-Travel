class RenameEndBudgetAndAddBudgetToBoards < ActiveRecord::Migration[7.0]
  def up
    # カラムのリネーム
    rename_column :boards, :end_budget, :end_duration
    
    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      # 新しい一時カラムを追加して、データを移行する
      add_column :boards, :end_duration_temp, :timestamp
      
      # 既存のintegerデータを新しいtimestampカラムに変換
      Board.reset_column_information
      Board.find_each do |board|
        if board.end_duration.present?
          # ここで適切に変換（たとえば、UNIXタイムスタンプとして扱う）
          board.update_column(:end_duration_temp, Time.at(board.end_duration).to_datetime)
        end
      end

      # 古いカラムを削除し、新しいカラムをリネーム
      remove_column :boards, :end_duration
      rename_column :boards, :end_duration_temp, :end_duration
    else
      # 他のデータベースではそのままdatetime型に変更
      change_column :boards, :end_duration, :datetime
    end
    
    # budgetカラムを追加
    add_column :boards, :budget, :integer
  end

  def down
    # 元に戻す場合の処理
    rename_column :boards, :end_duration, :end_budget

    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      add_column :boards, :end_budget_temp, :integer

      Board.reset_column_information
      Board.find_each do |board|
        if board.end_budget.present?
          board.update_column(:end_budget_temp, board.end_budget.to_i)
        end
      end

      remove_column :boards, :end_budget
      rename_column :boards, :end_budget_temp, :end_budget
    else
      change_column :boards, :end_budget, :integer
    end

    remove_column :boards, :budget
  end
end
