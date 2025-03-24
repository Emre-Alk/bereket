class VolunteeringsController < ApplicationController
  before_action :is_donator?

  def index
    @volunteerings = Volunteering.includes(:host_place).where(volunteer_id: current_user.donator.id)
  end

  def destroy

  end
end
