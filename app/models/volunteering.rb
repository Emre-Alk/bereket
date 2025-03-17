# == Schema Information
#
# Table name: volunteerings
#
#  id                     :bigint           not null, primary key
#  has_access_to_donation :boolean          default(FALSE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  host_place_id          :bigint           not null
#  volunteer_id           :bigint           not null
#
# Indexes
#
#  index_volunteerings_on_host_place_id  (host_place_id)
#  index_volunteerings_on_volunteer_id   (volunteer_id)
#
# Foreign Keys
#
#  fk_rails_...  (host_place_id => places.id)
#  fk_rails_...  (volunteer_id => donators.id)
#
class Volunteering < ApplicationRecord
  belongs_to :volunteer, class_name: 'Donator'
  belongs_to :host_place, class_name: 'Place'
end
