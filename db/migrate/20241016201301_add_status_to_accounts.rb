class AddStatusToAccounts < ActiveRecord::Migration[7.1]
  create_enum :account_status, %w[disabled active]
  def change
    add_column :accounts, :status, :enum, enum_type: 'account_status', default: 'active', null: false
  end
end
