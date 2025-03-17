# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  after_create :create_donator, if: :donator?, unless: :donator_exits_as_visitor?
  after_create :merge_donator, if: %i[donator? donator_exits_as_visitor?]
  after_update :update_donator, if: %i[donator? relevant_changes_for_donator?]

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :donator, dependent: :destroy
  has_one :asso, dependent: :destroy

  ROLES = %w[donator asso]

  validates :role,
            presence: true,
            inclusion: { in: ROLES }

  # to be removed (moved to donator at edit)
  validates :first_name, :last_name,
            presence: true,
            format: { with: /\A[A-Za-z]+(\s?[A-Za-z]*)*\z/, message: 'en letttres uniquement' }

  validates :email,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: 'format non valide' },
            uniqueness: true

  def donator?
    role == 'donator'
  end

  def asso?
    role == 'asso'
  end

  def owner?(place)
    return false unless asso

    asso.places.include?(place)
  end

  private

  def merge_donator
    donator = Donator.find_by(email:)
    donator.update!(first_name:, last_name:, status: 'enrolled', user_id: id)
  end

  def donator_exits_as_visitor?
    true if Donator.find_by(email:)
  end

  # to be deleted (duplicate attribute in user and donator)
  def relevant_changes_for_donator?
    %i[email first_name last_name].any? { |attribute| saved_change_to_attribute?(attribute) }
  end

  # to be deleted (duplicate attribute in user and donator)
  def update_donator
    donator.update!(first_name:, last_name:, email:)
  end

  # custom callback helper to create a donator after sign-up registration by devise if user has set a donator role
  # I do that since at that point donator has the same attributes as user attributes resquested in the registration page
  def create_donator
    # here are several methods possible to do the same using usual active record method 'create!' or devise methods
    # using active record method:
    # Donator.create!(first_name: user.first_name, last_name: user.last_name, email: user.email, user_id: user.id)
    # using devise helper methods:
    create_donator!(first_name:, last_name:, email:, user_id: id, status: 'enrolled')
    # does the same as above but using devise method .create_'has_one' (rq: association must exist)
    # code below does also the same, using another devise method (rq: association must exist)
    # donator = build_donator(first_name: user.first_name, last_name: user.last_name, email: user.email, user_id: user.id)
  end
end
