class CreatePlaces < ActiveRecord::Migration[7.1]
  def change
    create_table :places do |t|
      t.string :name
      t.string :address
      t.string :street_no
      t.string :city
      t.string :country
      t.references :asso, null: false, foreign_key: true

      t.timestamps
    end
  end
end
