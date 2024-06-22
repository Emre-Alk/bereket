class AddQrCodeToPlace < ActiveRecord::Migration[7.1]
  def change
    add_column :places, :qr_code, :string
  end
end
