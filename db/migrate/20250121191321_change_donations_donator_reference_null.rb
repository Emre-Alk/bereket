class ChangeDonationsDonatorReferenceNull < ActiveRecord::Migration[7.1]
  def change
    reversible do |direction|
      direction.up do
        change_column_null :donations, :donator_id, true
      end

      direction.down do
        change_column_null :donations, :donator_id, false
      end

    end
  end
end
