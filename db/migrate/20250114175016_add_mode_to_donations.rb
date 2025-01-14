class AddModeToDonations < ActiveRecord::Migration[7.1]
  def change
    # add new column
    add_column :donations, :mode, :string, null: false, default: 'virement, prélèvement, carte bancaire'

    # update existing records with a default value (active record would not know how to reverse it so use reversible block)
    reversible do |direction|
      direction.up do
        Donation.update_all(mode: 'virement, prélèvement, carte bancaire')
      end

      direction.down do
        Donation.update_all(mode: nil)
      end
    end
  end
end
