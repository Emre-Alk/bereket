# == Schema Information
#
# Table name: accounts
#
#  id                       :bigint           not null, primary key
#  charges_enabled          :boolean
#  last_four                :string
#  payouts_enabled          :boolean
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
end
