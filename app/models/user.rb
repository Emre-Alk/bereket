class User < ApplicationRecord
  after_create :create_donator
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :donator, dependent: :destroy
  has_one :asso, dependent: :destroy

  ROLES = %w[donator asso]

  validates :role, presence: true
  validates :role, inclusion: { in: ROLES }
  validates :first_name, :last_name, format:{ with: /\A[a-zA-Z]+\z/,
    message: "letttres uniquement" }

  def donator?
    role == 'donator'
  end

  def asso?
    role == 'asso'
  end

  private

  # custom callback helper to create a donator after sign-up registration by devise if user has set a donator role
  # I do that since at that point donator has the same attributes as user attributes resquested in the registration page
  def create_donator
    user = self
    if user.donator?
      # here are several methods possible to do the same using usual active record method 'create!' or devise methods
      # using active record method:
      # Donator.create!(first_name: user.first_name, last_name: user.last_name, email: user.email, user_id: user.id)
      # using devise helper methods:
      user.create_donator!(first_name: user.first_name, last_name: user.last_name, email: user.email, user_id: user.id)
      # does the same as above but using devise method .create_'has_one' (rq: association must exist)
      # code below does also the same, using another devise method (rq: association must exist)
      # donator = build_donator(first_name: user.first_name, last_name: user.last_name, email: user.email, user_id: user.id)
    end
  end
end
