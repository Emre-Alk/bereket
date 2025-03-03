# == Schema Information
#
# Table name: customers
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  donator_id :bigint           not null
#  stripe_id  :string
#
# Indexes
#
#  index_customers_on_donator_id  (donator_id)
#
# Foreign Keys
#
#  fk_rails_...  (donator_id => donators.id)
#
class Customer < ApplicationRecord
  before_destroy :delete_customer_on_stripe, if: -> { donator.enrolled? }, unless: :is_deleted?

  belongs_to :donator

  validates :stripe_id, :donator_id, presence: true
  validates :stripe_id, :donator_id, uniqueness: true

  private

  def delete_customer_on_stripe
    Stripe::Customer.delete(stripe_id)
  end

  def is_deleted?
    Stripe::Customer.retrieve(stripe_id)
  end
end
