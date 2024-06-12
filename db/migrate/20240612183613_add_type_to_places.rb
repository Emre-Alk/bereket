class AddTypeToPlaces < ActiveRecord::Migration[7.1]
  def change
    add_reference :places, :place_types, null: false, foreign_key: true
  end
end
