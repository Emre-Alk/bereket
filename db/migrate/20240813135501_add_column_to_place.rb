class AddColumnToPlace < ActiveRecord::Migration[7.1]
  def change
    add_column :places, :zip_code, :string
  end
end
