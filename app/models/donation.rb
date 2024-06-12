class Donation < ApplicationRecord
  belongs_to :donator
  belongs_to :place

  validates :amount, :occured_on, presence: true
  validates :amount, numericality: true
end
