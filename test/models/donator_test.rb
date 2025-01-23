# == Schema Information
#
# Table name: donators
#
#  id         :bigint           not null, primary key
#  address    :string
#  country    :string
#  email      :string
#  first_name :string
#  last_name  :string
#  status     :enum             default("visitor"), not null
#  zip_code   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_donators_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class DonatorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
