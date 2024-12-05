# frozen_string_literal: true

class CreateBoards < ActiveRecord::Migration[7.0]
  def change
    create_table :boards do |t|
      t.integer :user_id, null: false
      t.string :place_name
      t.datetime :start_duration
      t.integer :end_budget
      t.text :body

      t.timestamps
    end
  end
end
