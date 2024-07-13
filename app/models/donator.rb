class Donator < ApplicationRecord
  belongs_to :user
  has_many :donations
  has_many :places, through: :donations
  has_many :favorites
  has_one_attached :profile_image


  validates :first_name, :last_name, :email, presence: true
end
