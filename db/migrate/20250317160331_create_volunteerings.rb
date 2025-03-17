class CreateVolunteerings < ActiveRecord::Migration[7.1]
  def change
    create_table :volunteerings do |t|
      t.references :volunteer, null: false, foreign_key: { to_table: :donators }
      t.references :host_place, null: false, foreign_key: { to_table: :places }
      t.boolean :has_access_to_donation, default: false

      t.timestamps
    end
  end
end
