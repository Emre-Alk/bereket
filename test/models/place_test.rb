# == Schema Information
#
# Table name: places
#
#  id            :bigint           not null, primary key
#  address       :string
#  city          :string
#  country       :string
#  name          :string
#  qr_code       :string
#  street_no     :string
#  zip_code      :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  asso_id       :bigint           not null
#  place_type_id :bigint           not null
#
# Indexes
#
#  index_places_on_asso_id        (asso_id)
#  index_places_on_place_type_id  (place_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (asso_id => assos.id)
#  fk_rails_...  (place_type_id => place_types.id)
#
require "test_helper"

class PlaceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
