class ChangeEndDurationTypeInBoards2 < ActiveRecord::Migration[7.0]
  def up
    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      change_column :boards, :end_duration, 'timestamp USING end_duration::timestamp without time zone'
    end
  end

  def down
    if ActiveRecord::Base.connection.adapter_name == 'PostgreSQL'
      change_column :boards, :end_duration, :date
    end
  end
end
