class AddCheckoutSessionIdToDonations < ActiveRecord::Migration[7.1]
  def change
    add_column :donations, :checkout_session_id, :string
  end
end
