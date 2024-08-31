class AddExternalBankAccountLastFourToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :last_four, :string
  end
end
