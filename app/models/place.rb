class Place < ApplicationRecord
  belongs_to :asso
  has_many :donations
  has_many :donators, through: :donations
  belongs_to :place_type

  # validation presence pour place_type_id?
  validates :name, :address, :street_no, :city, :country, presence: true
end
