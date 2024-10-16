class AddRequirementsToAccounts < ActiveRecord::Migration[7.1]
  create_enum :requirement_status, %w[past currently eventually clear]
  def change
    add_column :accounts, :requirements, :enum, enum_type: 'requirement_status', default: 'clear', null: false
  end
end
