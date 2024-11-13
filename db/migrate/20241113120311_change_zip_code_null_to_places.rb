class ChangeZipCodeNullToPlaces < ActiveRecord::Migration[7.1]
  def change
    reversible do |direction|
      direction.up do
        Place.update_all(zip_code: '69000')
      end

      direction.down do
        Place.update_all(zip_code: nil )
      end
    end

    change_column_null :places, :zip_code, false
  end
end
