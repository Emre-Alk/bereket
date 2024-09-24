class AddDonationRefToReviews < ActiveRecord::Migration[7.1]
  def change
    add_reference :reviews, :donation, null: false, foreign_key: true
  end
end
