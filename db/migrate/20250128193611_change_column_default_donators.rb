class ChangeColumnDefaultDonators < ActiveRecord::Migration[7.1]
  def change
    reversible do |direction|
      direction.up do
        change_column_default :donators, :status, from: 'visitor', to: 'enrolled'
      end

      direction.down do
        change_column_default :donators, :status, from: 'enrolled', to: 'visitor'
      end
    end
  end
end
