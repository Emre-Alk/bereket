class VolunteeringsController < ApplicationController
  before_action :is_donator?

  def index
    @volunteerings =
      current_user
      .donator
      .volunteerings
      .includes(host_place: [:donations, { place_image_attachment: :blob }])
      .where.not(status: :archived)
      .order(status: :asc)
  end

  def paused
    donator = current_user.donator
    @volunteering = donator.volunteerings.find(params[:id])

    # return redirect_to donator_volunteerings_path(donator) if @volunteering.status_pending? || @volunteering.status_archived?

    case @volunteering.status
    when 'paused'
      @volunteering.status_active!
    when 'active'
      @volunteering.status_paused!
    else
      # fail safe in case requested a 'paused' on a pending or archived record
      return redirect_to donator_volunteerings_path(current_user.donator)
    end

    redirect_to donator_volunteerings_path(current_user.donator)
  end

  def destroy
    @volunteering = current_user.donator.volunteerings.find(params[:id])
    @volunteering.status_archived!
    redirect_to donator_volunteerings_path(current_user.donator)
  end
end
