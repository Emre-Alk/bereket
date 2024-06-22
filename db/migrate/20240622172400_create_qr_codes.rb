class CreateQrCodes < ActiveRecord::Migration[7.1]
  def change
    create_table :qr_codes do |t|
      t.string :url
      t.references :place, null: false, foreign_key: true

      t.timestamps
    end
  end
end
