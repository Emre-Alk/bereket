class AssoType < ApplicationRecord
  VALUES = [
    "organismes d'intérêt général ou reconnu d'utilité publique établis en France",
    "organismes d'aide aux personnes en difficulté",
    "Fondation du Patrimoine pour la conservation du patrimoine immobilier religieux"
  ].freeze

  validates :name, presence: true, inclusion: { in: VALUES }
  # to restrain the user to select only one value in a select tag in the form,
  # use f.select :name, options_for_select(AssoType::VALUES)
end
