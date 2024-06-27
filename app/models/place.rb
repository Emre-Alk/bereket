class Place < ApplicationRecord
  belongs_to :asso
  belongs_to :place_type
  has_many :donations
  has_many :donators, through: :donations
  has_one_attached :qr_image
  has_one_attached :place_image

  # validation presence pour place_type_id?
  # validation pour format place_image ?
  validates :name, :address, :street_no, :city, :country, presence: true
end
