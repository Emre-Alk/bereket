class PlacesController < ApplicationController
  skip_before_action :authenticate_user!
  # before_action :set_place
  layout "profile"

  def show
    # set the local to fr for this action only
    I18n.locale = :fr
    @place = Place.find(params[:id])
    # identify donator if signed_in
    @donator = current_user&.donator
    # find if place is in favorite list of donator
    @favorite = @place.favorites.where(donator: @donator).take
    # retrieve all the review on this place
    # 'includes' will load all donations and from all donators when loading place so that N+1 query is avoided
    @reviews = @place.reviews.includes(donation: :donator)
    # calculate the score based on ratings if there is at least one review else set to 0
    @score = @reviews.presence ? @reviews.sum(&:rating).fdiv(@reviews.length) : 0
  end

  def attach_qrcode
    place = Place.find(params[:place_id])
    # svg = qr_generate(@place)
    # send_data(
    #   svg,
    #   type: "image/svg+xml",
    #   filename: "dynamic-graphic.svg",
    #   disposition: "attachment"
    # )
    service_qrcode = QrGenerator.new(place)

    qrcode = service_qrcode.qr_generate

    upload_url = service_qrcode.upload_cloud(qrcode)

    file = URI.parse(upload_url['secure_url']).open
    place_name = place.name.split(' ').map(&:upcase).join(' ')

    place.qr_image.attach(
      io: file,
      filename: "place_#{place_name}_qrcode.png"
    )
  end

  # private

  # def set_place
  #   @place = Place.find(params[:id])
  # end
end
