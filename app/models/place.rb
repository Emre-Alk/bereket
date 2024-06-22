class Place < ApplicationRecord
  belongs_to :asso
  belongs_to :place_type
  has_many :donations
  has_many :donators, through: :donations

  # validation presence pour place_type_id?
  validates :name, :address, :street_no, :city, :country, presence: true
end
