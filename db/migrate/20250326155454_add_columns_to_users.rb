class AddColumnsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string

    reversible do |direction|
      direction.up do

        User.all.each do |user|
          user.update(first_name: user.donator.first_name, last_name: user.donator.last_name) if user.donator?
        end
      end

      direction.down do
        User.update_all(first_name: nil, last_name: nil)
      end
    end
  end
end
