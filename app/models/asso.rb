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
class Asso < ApplicationRecord
  belongs_to :user
  has_many :places, dependent: :destroy
  has_one :asso_type
  has_one_attached :profile_image
  has_one_attached :signature # feature_signature
  has_one :account, dependent: :destroy # check if yt done the same

  # validation presence pour asso_type_id ?
  # validations sur siret et siren à faire si necessaire sinon voir si peut supprimer ces deux attributs
  validates :name, :email, :code_nra, presence: true
  validates :name, :code_nra, uniqueness: true
  validates :email, uniqueness: true, unless: -> { email == user.email }
  validates :code_siret, :code_siren, uniqueness: true, allow_nil: true
  validates :code_nra, length: { is: 10 }
  validates :code_nra, format: {
    with: /\A[wW]\d{9}\z/,
    message: "Votre code NRA doit commencer par 'W' suivi des 9 chiffres"
  }
end
