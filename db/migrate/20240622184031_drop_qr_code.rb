class DropQrCode < ActiveRecord::Migration[7.1]
  def change
    drop_table :qr_codes
  end
end
