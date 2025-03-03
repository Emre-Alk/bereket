class ChangeUserRefNullToDonators < ActiveRecord::Migration[7.1]
  def change
    reversible do |direction|
      direction.up do
        change_column_null :donators, :user_id, true
      end

      direction.down do
        change_column_null :donators, :user_id, false
      end
    end
  end
end
