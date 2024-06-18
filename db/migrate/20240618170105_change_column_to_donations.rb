class ChangeColumnToDonations < ActiveRecord::Migration[7.1]
  def change
    change_column :donations, :amount, :integer
  end
end
