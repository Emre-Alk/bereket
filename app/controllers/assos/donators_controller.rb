class Assos::DonatorsController < AssosController
  def index
    @donations = Donation.includes(place: :asso).where(places: { asso_id: current_user.asso.id })
    @donations_per_donator = @donations.group_by(&:donator) # {donator: [instance don]}
    @top_donators = @donations_per_donator.map { |donator, dons| [donator, dons.sum(&:amount_net)] }
    @top_donators_sorted = @top_donators.sort_by { |_donator, total| -total }
  end
end
