class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.string :stripe_id
      t.references :donator, null: false, foreign_key: true

      t.timestamps
    end
  end
end
