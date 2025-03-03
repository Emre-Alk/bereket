class AddColumnsNullToDonators < ActiveRecord::Migration[7.1]
  def change
    change_column_null :donators, :address, true
    change_column_null :donators, :city, true
    change_column_null :donators, :zip_code, true
    change_column_null :donators, :country, true
  end
end
