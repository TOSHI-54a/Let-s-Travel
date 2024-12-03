# frozen_string_literal: true

class AddNotNullConstraintToCommentColumn < ActiveRecord::Migration[7.0]
  def change
    change_column_null :comments, :body, false
  end
end
