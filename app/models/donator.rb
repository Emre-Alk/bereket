class Donator < ApplicationRecord
  belongs_to :user
  has_many :donations
  has_many :places, through: :donations

  validates :first_name, :last_name, :email, presence: true
end
