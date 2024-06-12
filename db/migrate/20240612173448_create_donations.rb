class CreateDonations < ActiveRecord::Migration[7.1]
  def change
    create_table :donations do |t|
      t.references :donator, null: false, foreign_key: true
      t.references :place, null: false, foreign_key: true
      t.float :amount
      t.datetime :occured_on

      t.timestamps
    end
  end
end
