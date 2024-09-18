# == Schema Information
#
# Table name: reviews
#
#  id         :bigint           not null, primary key
#  content    :text
#  rating     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  donator_id :bigint           not null
#
# Indexes
#
#  index_reviews_on_donator_id  (donator_id)
#
# Foreign Keys
#
#  fk_rails_...  (donator_id => donators.id)
#
require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
