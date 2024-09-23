class AddStatusToDonators < ActiveRecord::Migration[7.1]
  create_enum :donator_status, %w[visitor enrolled]
  def change
    add_column :donators, :status, :enum, enum_type: 'donator_status', default: 'visitor', null: false
  end
end
