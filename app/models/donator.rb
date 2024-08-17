class Donator < ApplicationRecord
  belongs_to :user
  has_many :donations
  has_many :places, through: :donations
  has_many :favorites, dependent: :destroy
  # has_many :places, through: :favorites
  has_one_attached :profile_image # service not specified and config active storage is default cloudinary => thus, store on cloud
  has_one_attached :cerfa, service: :local # Use local disk for user PDFs


  validates :first_name, :last_name, :email, presence: true
end
