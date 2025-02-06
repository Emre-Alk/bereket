class DonatorsController < ApplicationController
  # authenticate user is devise callback helper for authentication
  # is donator is my custom callback helper for authorization
  before_action :is_donator?

  def dashboard
    # --- query initializers ----
    # set the donator object
    @donator = current_user.donator
    # array de tous ses dons
    @donations = @donator.donations
    # --- son total dons ----
    # create an hash with 'key' being a place object and 'value' being all donations objects having this place association
    # hash: { obj_placeA: [obj_don1, obj_don6,...], obj_placeB: [obj_don2, ...]...}
    @donations_per_place = @donations.group_by(&:place)
    # array: [[obj_placeA, somme des dons à ce lieu], [x, y], ...]
    @sum_per_place = @donations_per_place.map { |place, dons| [place, dons.sum(&:amount)] }
    @total = @donations_per_place.sum { |_place, dons| dons.sum(&:amount) }
    @total_discount = @total * 0.66
    @total_net = @total - @total_discount
    # --- ses 10 derniers dons ---
    @sorted_donations = @donations.order(created_at: :desc)
    # --- ses favoris ---
    @favorites = @donator.favorites
  end

  # def create
  #   @donator = Donator.new
  #   @donator.first_name = current_user.first_name
  #   @donator.last_name = current_user.last_name
  #   @donator.email = current_user.email

  #   if @donator.save
  #     render :dashboard
  #   else
  #     redirect_to new_registration_path(@donator), status: :unprocessable_entity
  #   end
  # end

  def edit
    @donator = Donator.find(params[:id])
  end

  def update
    @donator = Donator.find(params[:id])

    respond_to do |format|
      if @donator.update(donator_params)
        format.html { redirect_to donator_root_path, notice: 'Les modifications ont été sauvegardées avec succès' }
        format.json { render json: { message: 'success', status: :ok } }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @donator.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def donator_params
    params.require(:donator).permit(
      :address,
      :zip_code,
      :city,
      :country,
      :profile_image,
      user_attributes: [:email, :first_name, :last_name, :id]
    )
  end
end
