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
require "test_helper"

class CustomerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
