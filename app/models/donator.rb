# == Schema Information
#
# Table name: donators
#
#  id         :bigint           not null, primary key
#  email      :string
#  first_name :string
#  last_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_donators_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Donator < ApplicationRecord
  after_create :create_customer
  after_update :update_customer

  belongs_to :user
  has_many :donations
  has_many :places, through: :donations
  has_many :favorites, dependent: :destroy
  # has_many :places, through: :favorites
  has_one_attached :profile_image # service not specified and config active storage is default cloudinary => thus, store on cloud
  has_one_attached :cerfa #, service: :local # Use local disk for user PDFs
  has_one :customer, dependent: :destroy

  validates :first_name, :last_name, :email, presence: true

  private

  def create_customer
    donator = self
    customer = Stripe::Customer.create(
      email: donator.email,
      name: "#{donator.first_name} #{donator.last_name}"
    )
    donator.create_customer!(donator_id: donator.id, stripe_id: customer.id)
  end

  def update_customer
    donator = self
    customer = Stripe::Customer.update(
      donator.customer.stripe_id,
      {
        email: donator.email,
        name: "#{donator.first_name} #{donator.last_name}"
      }
    )
  end
end
