class AddColumnToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :role, :integer, null: false
  end
end
