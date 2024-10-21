class AddNotNullConstraintToSavingColumn < ActiveRecord::Migration[7.0]
  def change
    change_column_null :savings, :value, false
  end
end
