class AddColumnToDonators < ActiveRecord::Migration[7.1]
  def change
    add_column :donators, :completed, :boolean, null: false, default: false

    reversible do |direction|
      direction.up do
        Donator.update_all(completed: false)
      end

      direction.down do
        Donator.update_all(completed: false)
      end
    end
  end
end
