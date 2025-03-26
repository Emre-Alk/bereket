class Assos::DonatorsController < AssosController
  def index
    donations = current_user.asso.donations.includes(donator: [profile_image_attachment: :blob])
    donations_per_donator = donations.group_by(&:donator).map { |donator, dons| [donator, dons.sum(&:amount_net)] }
    @top_donators_sorted = donations_per_donator.sort_by { |_donator, total| -total }
  end
end
