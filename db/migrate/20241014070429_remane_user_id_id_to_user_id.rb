# frozen_string_literal: true

class RemaneUserIdIdToUserId < ActiveRecord::Migration[7.0]
  def change
    rename_column :savings, :user_id_id, :user_id
  end
end
