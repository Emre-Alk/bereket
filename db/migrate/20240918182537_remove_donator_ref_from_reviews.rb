class RemoveDonatorRefFromReviews < ActiveRecord::Migration[7.1]
  def change
    remove_reference :reviews, :donator, null: false, foreign_key: true
  end
end
