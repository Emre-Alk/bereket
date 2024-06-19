class ChangeTypeToPlaces < ActiveRecord::Migration[7.1]
  def change
    rename_column :places, :place_types_id, :place_type_id
  end
end
