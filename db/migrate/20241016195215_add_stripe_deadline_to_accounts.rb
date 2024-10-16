class AddStripeDeadlineToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :stripe_deadline, :datetime
  end
end
