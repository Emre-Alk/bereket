# == Schema Information
#
# Table name: accounts
#
#  id                       :bigint           not null, primary key
#  charges_enabled          :boolean
#  last_four                :string
#  payouts_enabled          :boolean
#  requirements             :enum             default("clear"), not null
#  status                   :enum             default("active"), not null
#  stripe_deadline          :datetime
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  asso_id                  :bigint           not null
#  external_bank_account_id :string
#  stripe_id                :string
#
# Indexes
#
#  index_accounts_on_asso_id  (asso_id)
#
# Foreign Keys
#
#  fk_rails_...  (asso_id => assos.id)
#
class Account < ApplicationRecord
  belongs_to :asso

  enum :requirements, {
    past: 'past',
    currently: 'currently',
    eventually: 'eventually',
    clear: 'clear'
  }, default: 'clear'

  enum :status, {
    disabled: 'disabled',
    active: 'active'
  }, default: 'active'
end
