# == Schema Information
#
# Table name: donators
#
#  id         :bigint           not null, primary key
#  address    :string
#  city       :string
#  completed  :boolean          default(FALSE), not null
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
  after_create :create_customer, if: -> { enrolled? } # No customer object if not a registered user (ie, visitor)
  after_save :update_completed, unless: -> { saved_change_to_completed? }
  after_update :update_customer, if: :stripe_update_needed?, unless: -> { saved_change_to_status?(from: 'visitor') } # unless update triggered by donator changes from visitor to enrolled (ie, new user)
  after_update :create_customer, if: -> { saved_change_to_status?(from: 'visitor') } # if donator changes from visitor (ie, new user)

  has_one :customer, dependent: :destroy

  belongs_to :user, optional: true # to create a donator as a visitor and bypasing user creation which brings in complexity
  accepts_nested_attributes_for :user # update user model attributes within a donator edit for

  has_many :donations
  has_many :places, through: :donations
  has_many :favorites, dependent: :destroy
  has_many :reviews, through: :donations
  has_many :volunteerings, foreign_key: :volunteer_id # The explcit foreign_key ensures Rails to look for volunteer_id in volunteerings. Without it, it will look for donator_id.
  has_many :host_places, through: :volunteerings, source: :host_place # The has_many :host_places in Donator would try to look for a host_places (plural) association in Volunteering, but our column is named host_place_id. Source will tell rails to look for the association name 'host_place' (singular)
  # source = Used in 'has_many :through' associations to specify the association name inside the join model.
  # foreign_key = Used only for direct associations, while source is specifically required when dealing with a 'has_many :through' association (indirect).

  has_one_attached :profile_image, dependent: :destroy # service not specified and config active storage is default cloudinary => thus, store on cloud
  has_one_attached :cerfa, dependent: :destroy #, service: :local # Use local disk for user PDFs

  enum :status, {
    visitor: 'visitor',
    enrolled: 'enrolled'
  }, default: 'enrolled'

  validates :first_name, :last_name,
            allow_blank: true, # to allow user creation without asking for FN and LN for after_create: :create_donator callback to work
            # presence: true,
            format: { with: /\A[A-Za-z]+(\s?[A-Za-z]*)*\z/, message: 'en letttres uniquement' }

  validates :address,
            allow_blank: true,
            format: { with: /\A\d{1,3}\s[a-zA-Z0-9éÉàÀèÈùÙçÇ'\-\s]+\z/, message: 'sans caractère spécial (. , § @ + )' }

  validates :zip_code,
            format: { with: /\A\d{5}\z/, message: 'max. 5 chiffres uniquement' },
            allow_blank: true

  validates :country,
            format: { with: /\A[a-zA-ZéÉàÀèÈùÙçÇ'\-\s]{2,50}\z/, message: 'en letttres uniquement' },
            allow_blank: true

  validates :city,
            format: { with: /\A[a-zA-ZéÉàÀèÈùÙçÇ'\-\s]{2,50}\z/, message: 'en letttres uniquement' },
            allow_blank: true

  private

  def update_completed
    # whitelist = attribute_names.excluding('id', 'user_id', 'created_at', 'updated_at', 'status', 'completed')
    # whitelist = %w[first_name last_name address zip_code country city]
    whitelist = %w[address zip_code country city]

    new_value = whitelist.all? { |attribute| attribute_present?(attribute) }

    return if completed == new_value

    update!(completed: new_value)
  end

  # def relevant_changes_for_user?
  #   %i[email first_name last_name].any? { |attribute| saved_change_to_attribute?(attribute) }
  # end

  def create_customer
    return if customer.present?

    new_customer = Stripe::Customer.create(
      email:,
      name: "#{first_name} #{last_name}"
    )
    create_customer!(stripe_id: new_customer.id)
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
