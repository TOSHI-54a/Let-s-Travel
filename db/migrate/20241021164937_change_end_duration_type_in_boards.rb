# frozen_string_literal: true

class ChangeEndDurationTypeInBoards < ActiveRecord::Migration[7.0]
  def up
    return unless ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'

    add_column :boards, :end_duration_temp, :timestamp

    Board.reset_column_information
    Board.find_each do |board|
      board.update_column(:end_duration_temp, board.end_duration.to_datetime) if board.end_duration.present?
    end

    remove_column :boards, :end_duration
    rename_column :boards, :end_duration_temp, :end_duration
  end

  def down
    return unless ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'

    add_column :boards, :end_duration_temp, :integer

    Board.reset_column_information
    Board.find_each do |board|
      board.update_column(:end_duration_temp, board.end_duration.to_i) if board.end_duration.present?
    end

    remove_column :boards, :end_duration
    rename_column :boards, :end_duration_temp, :end_duration
  end
end
