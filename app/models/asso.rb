class Asso < ApplicationRecord
  belongs_to :user
  has_many :places, dependent: :destroy
  has_one :asso_type

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
