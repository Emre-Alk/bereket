class AddColumnToDonations < ActiveRecord::Migration[7.1]
  def change
    add_column :donations, :amount_net, :integer
  end
end
