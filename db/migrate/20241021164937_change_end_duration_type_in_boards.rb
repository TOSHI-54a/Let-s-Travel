class ChangeEndDurationTypeInBoards < ActiveRecord::Migration[7.0]
  def up
    add_column :boards, :end_duration_temp, :timestamp
    Board.reset_column_information
    Board.find_each do |board|
      if board.end_duration.present?
        board.update_column(:end_duration_temp, board.end_duration.to_datetime)
      end
    end
    remove_column :boards, :end_duration
    rename_column :boards, :end_duration_temp, :end_duration
  end

  def down
    add_column :boards, :end_duration_temp, :date
    Board.reset_column_information
    Board.find_each do |board|
      if board.end_duration.present?
        board.update_column(:end_duration_temp, board.end_duration.to_date)
      end
    end
    remove_column :boards, :end_duration
    rename_column :boards, :end_duration_temp, :end_duration
  end
end
