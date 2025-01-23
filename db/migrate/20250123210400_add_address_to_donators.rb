class AddAddressToDonators < ActiveRecord::Migration[7.1]
  def change
    add_column :donators, :address, :string
    add_column :donators, :zip_code, :string
    add_column :donators, :country, :string
  end
end
