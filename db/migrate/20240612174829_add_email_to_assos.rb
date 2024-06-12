class AddEmailToAssos < ActiveRecord::Migration[7.1]
  def change
    add_column :assos, :email, :string
  end
end
