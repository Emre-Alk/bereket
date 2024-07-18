class Donation < ApplicationRecord
  belongs_to :donator
  belongs_to :place

  validates :amount, presence: true
  validates :amount, numericality: true
end
