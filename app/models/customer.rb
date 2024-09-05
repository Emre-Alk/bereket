# == Schema Information
#
# Table name: customers
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  donator_id :bigint           not null
#  stripe_id  :string
#
# Indexes
#
#  index_customers_on_donator_id  (donator_id)
#
# Foreign Keys
#
#  fk_rails_...  (donator_id => donators.id)
#
class Customer < ApplicationRecord
  belongs_to :donator
end
