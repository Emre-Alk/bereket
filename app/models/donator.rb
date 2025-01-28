# == Schema Information
#
# Table name: donators
#
#  id         :bigint           not null, primary key
#  address    :string
#  city       :string
#  country    :string
#  email      :string
#  first_name :string
#  last_name  :string
#  status     :enum             default("enrolled"), not null
#  zip_code   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
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
  after_update :update_customer, if: :stripe_update_needed?

  belongs_to :user, optional: true # to create a donator as a visitor and bypasing user creation which brings in complexity

  has_one :customer, dependent: :destroy

  has_many :donations
  has_many :places, through: :donations
  has_many :favorites, dependent: :destroy
  has_many :reviews, through: :donations

  has_one_attached :profile_image # service not specified and config active storage is default cloudinary => thus, store on cloud
  has_one_attached :cerfa #, service: :local # Use local disk for user PDFs

  enum :status, {
    visitor: 'visitor',
    enrolled: 'enrolled'
  }, default: 'enrolled'

  validates :status, presence: true
  validates :first_name, :last_name,
            format: { with: /\A[A-Za-z]+(\s?[A-Za-z]*)*\z/, message: 'letttres uniquement' },
            presence: true
  validates :email,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: true

  private

  def create_customer
    customer = Stripe::Customer.create(
      email:,
      name: "#{first_name} #{last_name}"
    )
    create_customer!(stripe_id: customer.id)
  end

  # check if any updates on donator is to be pass to stripe for customer
  # should cope with updates triggered by devise controllers (session#destroy/create etc...)
  def stripe_update_needed?
    saved_change_to_email? || saved_change_to_first_name? || saved_change_to_last_name?
  end

  def update_customer
    return unless customer.stripe_id # update only if customer already exist and has a stripe id

    # build a payload to pass the attributes stripe needs to update
    stripe_payload = {} # payload would have only key where condition is true
    stripe_payload[:email] = email if saved_change_to_email? # true if email was changed and saved

    if saved_change_to_first_name? || saved_change_to_last_name? # true if first or last name were changed and saved
      stripe_payload[:name] = [first_name, last_name].compact.join(' ') # compact in case first or last is nil for any reason
    end

    # perform the update in a job since not a critical update and cope in case of stripe api downtime
    StripeCustomerUpdateJob.perform_later(customer.stripe_id, stripe_payload)

    # donator = self
    # Stripe::Customer.update(
    #   donator.customer.stripe_id,
    #   {
    #     email: donator.email,
    #     name: "#{donator.first_name} #{donator.last_name}"
    #   }
    # )
  end
end
