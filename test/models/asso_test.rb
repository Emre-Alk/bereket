# == Schema Information
#
# Table name: assos
#
#  id           :bigint           not null, primary key
#  code_nra     :string
#  code_siren   :string
#  code_siret   :string
#  email        :string
#  name         :string
#  objet        :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  asso_type_id :bigint           not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_assos_on_asso_type_id  (asso_type_id)
#  index_assos_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (asso_type_id => asso_types.id)
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class AssoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
