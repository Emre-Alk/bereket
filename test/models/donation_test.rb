# == Schema Information
#
# Table name: donations
#
#  id                  :bigint           not null, primary key
#  amount              :integer
#  amount_net          :integer
#  mode                :string           default("virement, prélèvement, carte bancaire"), not null
#  occured_on          :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  checkout_session_id :string
#  donator_id          :bigint
#  place_id            :bigint           not null
#
# Indexes
#
#  index_donations_on_donator_id  (donator_id)
#  index_donations_on_place_id    (place_id)
#
# Foreign Keys
#
#  fk_rails_...  (donator_id => donators.id)
#  fk_rails_...  (place_id => places.id)
#
require "test_helper"

class DonationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
