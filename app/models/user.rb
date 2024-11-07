# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string           not null
#  last_name              :string           not null
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
  after_create :create_donator
  after_update :update_donator, if: :should_update_donator?
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :donator, dependent: :destroy
  has_one :asso, dependent: :destroy

  ROLES = %w[donator asso]

  validates :role, presence: true
  validates :role, inclusion: { in: ROLES }
  validates :first_name, :last_name, format: { with: /\A[A-Za-z]+(\s?[A-Za-z]*)*\z/,
    message: "letttres uniquement" }

  def donator?
    role == 'donator'
  end

  def asso?
    role == 'asso'
  end

  private

  def should_update_donator?
    self.donator? && self.relevant_changes_for_donator?
  end

  def relevant_changes_for_donator?
    %i[email first_name last_name].any? { |attribute| saved_change_to_attribute?(attribute) }
  end

  # custom callback helper to create a donator after sign-up registration by devise if user has set a donator role
  # I do that since at that point donator has the same attributes as user attributes resquested in the registration page
  def create_donator
    user = self
    if user.donator?
      # here are several methods possible to do the same using usual active record method 'create!' or devise methods
      # using active record method:
      # Donator.create!(first_name: user.first_name, last_name: user.last_name, email: user.email, user_id: user.id)
      # using devise helper methods:
      user.create_donator!(
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        user_id: user.id,
        status: 'enrolled'
      )
      # does the same as above but using devise method .create_'has_one' (rq: association must exist)
      # code below does also the same, using another devise method (rq: association must exist)
      # donator = build_donator(first_name: user.first_name, last_name: user.last_name, email: user.email, user_id: user.id)
    end
  end

  def update_donator
    user = self
    # return if user.asso? # add if: to callback

    user.donator.update!(first_name: user.first_name, last_name: user.last_name, email: user.email, status: 'enrolled')
  end
end
