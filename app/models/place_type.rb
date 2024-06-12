class PlaceType < ApplicationRecord
  VALUES = %w[Mosquée Eglise Synagogue].freeze

  validates :name, presence: true, inclusion: { in: VALUES }
  # to restrain the user to select only one value in a select tag in the form,
  # use f.select :name, options_for_select(PlaceType::VALUES)
end
