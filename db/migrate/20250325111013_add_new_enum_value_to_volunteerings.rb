class AddNewEnumValueToVolunteerings < ActiveRecord::Migration[7.1]
  def change
    reversible do |direction|
      direction.up do
        add_enum_value :volunteering_status, "paused", after: 'active'
      end
    end
  end
end
