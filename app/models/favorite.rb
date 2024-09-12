# == Schema Information
#
# Table name: favorites
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  donator_id :bigint           not null
#  place_id   :bigint           not null
#
# Indexes
#
#  index_favorites_on_donator_id  (donator_id)
#  index_favorites_on_place_id    (place_id)
#
# Foreign Keys
#
#  fk_rails_...  (donator_id => donators.id)
#  fk_rails_...  (place_id => places.id)
#
class Favorite < ApplicationRecord
  belongs_to :donator
  belongs_to :place
end
