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
#  zip_code      :string
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
class Place < ApplicationRecord
  belongs_to :asso
  belongs_to :place_type
  has_many :donations
  has_many :donators, through: :donations
  has_many :favorites, dependent: :destroy
  # has_many :donators, through: :favorites
  # if needed later 'has many donators through favorites' it can be use to list for a place who has added it to its favorites
  has_one_attached :qr_image
  has_one_attached :place_image

  # validation presence pour place_type_id?
  # validation pour format place_image ?
  validates :name, :address, :street_no, :city, :country, presence: true

  def is_favorite_of?(donator)
    self.favorites.where(donator:).empty? ? false : true
  end
end
