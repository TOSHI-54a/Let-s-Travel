# frozen_string_literal: true

class ChangeDataTypeToBoards < ActiveRecord::Migration[7.0]
  def change
    change_column :boards, :start_duration, :date
    change_column :boards, :end_duration, :date
  end
end
