# == Schema Information
#
# Table name: donations
#
#  id                  :bigint           not null, primary key
#  amount              :integer
#  amount_net          :integer
#  mode                :string           default("virement, prélèvement, carte bancaire"), not null
#  occured_on          :datetime
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  checkout_session_id :string
#  donator_id          :bigint
#  place_id            :bigint           not null
#
# Indexes
#
#  index_donations_on_donator_id  (donator_id)
#  index_donations_on_place_id    (place_id)
#
# Foreign Keys
#
#  fk_rails_...  (donator_id => donators.id)
#  fk_rails_...  (place_id => places.id)
#
class Donation < ApplicationRecord
  generates_token_for :donation_link, expires_in: 1.day do
    updated_at.to_i
  end

  generates_token_for :cerfa_access, expires_in: 60.seconds do
    updated_at.to_i # check if update at timestamp is relevant for the purpose cerfa_access
  end

  belongs_to :donator, optional: true # optional for the case 'manual cerfa' feature. null changed via migration
  belongs_to :place

  has_one :review

  validates :amount, presence: true
  validates :amount, numericality: true
  validates :mode, presence: true

  MODES = ['virement, prélèvement, carte bancaire', 'chèque', 'espèce']
  validates :mode, inclusion: { in: MODES }
end
