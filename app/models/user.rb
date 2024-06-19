class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :donator, dependent: :destroy
  has_one :asso, dependent: :destroy

  ROLES = %w[donator asso]

  validates :role, presence: true
  validates :role, inclusion: { in: ROLES }

  def donator?
    role == 'donator'
  end

  def asso?
    role == 'asso'
  end
end
