# frozen_string_literal: true

class ChangeBoardAddNullInBoards < ActiveRecord::Migration[7.0]
  def change
    change_column_null :boards, :place_name, false
    change_column_null :boards, :start_duration, false
    change_column_null :boards, :end_duration, false
    change_column_null :boards, :body, false
  end
end
