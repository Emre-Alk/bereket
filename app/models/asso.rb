class Asso < ApplicationRecord
  belongs_to :user
  has_many :places, dependent: :destroy
  has_one :asso_type

  # validation presence pour asso_type_id ?
  # validations sur siret et siren à faire si necessaire sinon voir si peut supprimer ces deux attributs
  validates :name, :email, :code_nra, presence: true
  validates :name, :email, :code_nra, :code_siret, :code_siren, uniqueness: true
  validates :code_nra, lenght: { is: 10 }
  validates :code_nra, format: {
    with: /^[W|w]+\d{9}$/,
    message: "Votre code NRA doit commencer par 'W' suivi des 9 chiffres"
  }
end
