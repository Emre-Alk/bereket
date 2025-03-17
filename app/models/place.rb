# == Schema Information
#
# Table name: places
#
#  id            :bigint           not null, primary key
#  address       :string
#  city          :string
#  country       :string
#  name          :string
#  qr_code       :string
#  street_no     :string
#  zip_code      :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  asso_id       :bigint           not null
#  place_type_id :bigint           not null
#
# Indexes
#
#  index_places_on_asso_id        (asso_id)
#  index_places_on_place_type_id  (place_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (asso_id => assos.id)
#  fk_rails_...  (place_type_id => place_types.id)
#
class Place < ApplicationRecord
  # callbacks
  after_create :generate_and_attach_qrcode

  # associations
  belongs_to :asso
  belongs_to :place_type
  has_many :donations
  has_many :donators, through: :donations
  has_many :favorites, dependent: :destroy
  has_many :reviews, through: :donations
  has_many :volunteerings
  has_many :volunteers, through: :volunteerings

  # has_many :donators, through: :favorites
  # if needed later 'has many donators through favorites' it can be use to list for a place who has added it to its favorites
  has_one_attached :qr_image
  has_one_attached :place_image

  # validations
  validates :name, :address, :street_no, :city, :country, presence: true
  # validation pour 'place_type_id' presence ?
  # validation pour format 'place_image' ?

  # methods inheritance
  def generate_and_attach_qrcode
    service_qrcode = QrGenerator.new(self)

    qrcode = service_qrcode.qr_generate

    filename = "qrcode_basic_#{Time.now.to_i}"

    qr_image.attach(
        io: StringIO.new(qrcode),
        filename: "#{filename}.svg",
        content_type: "image/svg+xml",
        metadata: { overwrite: true },
        key: "asso/#{asso.id}/places/#{id}/qrcodes/#{filename}"
      )
  end

  def favorite_of?(donator)
    favorites.where(donator:).exists?
  end
end
