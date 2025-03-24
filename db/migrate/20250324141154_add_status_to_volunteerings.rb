class AddStatusToVolunteerings < ActiveRecord::Migration[7.1]
  create_enum :volunteering_status, %w[
    pending
    active
    archived
  ]
  def change
    add_column :volunteerings, :status, :enum, enum_type: 'volunteering_status', default: 'pending', null: false
  end
end
