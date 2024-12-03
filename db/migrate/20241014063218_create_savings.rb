# frozen_string_literal: true

class CreateSavings < ActiveRecord::Migration[7.0]
  def change
    create_table :savings do |t|
      t.references :user_id, null: false, foeign_key: true
      t.date :date_and_time
      t.integer :value

      t.timestamps
    end
  end
end
