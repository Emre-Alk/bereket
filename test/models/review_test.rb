# == Schema Information
#
# Table name: reviews
#
#  id          :bigint           not null, primary key
#  content     :text
#  rating      :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  donation_id :bigint           not null
#
# Indexes
#
#  index_reviews_on_donation_id  (donation_id)
#
# Foreign Keys
#
#  fk_rails_...  (donation_id => donations.id)
#
require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
