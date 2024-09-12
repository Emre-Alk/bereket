class AddExternalBankAccountIdToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :external_bank_account_id, :string
  end
end
