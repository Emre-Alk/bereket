# == Schema Information
#
# Table name: place_types
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class PlaceType < ApplicationRecord
  has_many :places
  VALUES = %w[Mosquée Eglise Synagogue]

  validates :name, presence: true, inclusion: { in: VALUES }
  # to restrain the user to select only one value in a select tag in the form,
  # use f.select :name, options_for_select(PlaceType::VALUES)
end
