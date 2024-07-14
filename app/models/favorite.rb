class Favorite < ApplicationRecord
  belongs_to :donator
  belongs_to :place
end
