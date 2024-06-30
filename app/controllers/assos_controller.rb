class AssosController < ApplicationController
  before_action :authenticate_user!
  before_action :is_asso?

  def dashboard
    @my_asso = current_user.asso
    @my_place = @my_asso.places.first # "first" afin de faire simple pour l'exemple mais reprendre pour carousselle
    @donations = @my_place.donations # array of all donations instances
    table = @donations.map { |i| [i.donator, i.amount] }
    # ===== somme des dons à date ===== start
    @sum = 0
    table.each do |e|
      @sum += e[1]
    end
    # ===== somme des dons à date ===== end
    # ===== top donateurs ===== start
    hash = {}
    table.each do |e|
      if hash.key?(e[0])
        hash[e[0]] += e[1]
      else
        hash[e[0]] = e[1]
      end
    end
    @top_donators = hash.sort_by { |donateur, total| -total }.to_h
    # ===== top donateurs ===== end

    # ===== last donations (plus recent au plus ancien) ===== start
    @sorted_donations = @donations.order(occured_on: :desc)
    # ===== last donations (plus recent au plus ancien) ===== end

    # ===== revenue of the current month ===== start
    start_month = Date.today.beginning_of_month
    end_month = Date.today.end_of_month
    # current_month sent to the view so can fetch it to the chart.js controller with stymulus for setting the time axis
    current_month = (start_month..end_month)
    # here I filter all donations occured this month
    @donations_current_month = @donations.where(occured_on: current_month).order(occured_on: :desc)
    # creer un hash dont 'key' sera 1 jour du mois (ex: Thu, 27, Jun 2024), et la 'value' sera un array des dons qui auront la meme "occured_on"
    @donations_per_day_current_month = @donations_current_month.group_by { |don| don.occured_on.to_date }
    # creer un array avec jour du mois (key) en numéro de jour (ex 27) et la 'value' egale à la somme des 'ammout' des dons dans l'array de dons précédent
    @revenue_per_day_current_month = @donations_per_day_current_month.map { |date, dons| [date.strftime('%d'), dons.sum(&:amount)] }
    # The &: syntax is shorthand for converting a symbol to a proc (a block of code). It is equivalent to "dons.sum { |don| don.amount }"
    # if is necessary for the case where no donation occured on a day. This would led to the absence of this day in the above revenue array.
    if @revenue_per_day_current_month.length < current_month.to_a.length
      # pour pouvoir utiliser la methode 'fetch' plus bas
      revenue_hash = @revenue_per_day_current_month.to_h
      # créer un array de jour du mois complet pour pouvoir le comparer avec @revenue...month et deceler des jours manquants
      @array_complete_days_current_month = current_month.to_a.map { |day| day.strftime('%d') }
      # pour chaque jour manquant dans revenue, je remplace la indice[1] par 0 => ex [[26,x€], [27, 0]...[30,x€]]
      revenue_complete_days_current_month = @array_complete_days_current_month.map { |day| [day, revenue_hash.fetch(day, 0)] }
      @revenue_per_day_current_month = revenue_complete_days_current_month
    end
    # ===== revenue of the current month ===== end
  end

  def new
    @asso = Asso.new
    @asso.email = current_user.email
  end

  def create
    @asso = Asso.new(set_asso_params)
    @asso.user = current_user
    if @asso.save
      redirect_to asso_root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_asso_params
    params.require(:asso).permit(:name, :code_nra, :email, :asso_type_id)
  end
end
