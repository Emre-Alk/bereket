class AssosController < ApplicationController
  # authenticate user is devise callback helper for authentication
  # is donator is my custom callback helper for authorization
  before_action :is_asso?

  def dashboard
    @my_asso = current_user.asso
    return @asso = Asso.new, @asso.email = current_user.email unless @my_asso

    @my_place = @my_asso.places.includes(:donations).first # "first" afin de faire simple pour l'exemple mais reprendre pour carousselle
    return @place = Place.new unless @my_place

    @donations = @my_place.donations.includes(donator: [profile_image_attachment: :blob]) # array of all donations instances
    # ===== somme des dons à date ===== start
    # ===== somme des dons à date ===== end
    # ===== top donateurs ===== start
    donations_per_donator = @donations.group_by(&:donator)
    top_donators = donations_per_donator.map { |donator, dons| [donator, dons.sum(&:amount_net)] }
    @top_donators_sorted = top_donators.sort_by { |_donator, total| -total }
    # ===== top donateurs ===== end

    # ===== last donations (plus recent au plus ancien) ===== start
    @sorted_donations = @donations.order(created_at: :desc)
    # ===== last donations (plus recent au plus ancien) ===== end

    # ===== revenue of the current month ===== start
    @start_month = Date.today.beginning_of_month
    # astuce car 'Date.today' seul ne comptera pas les dons du cours de la journée car occured_on etc.. de class Time
    end_month = Date.today.end_of_month
    # current_month sent to the view so can fetch it to the chart.js controller with stymulus for setting the time axis
    @current_month = (@start_month..end_month)
    # here I filter all donations occured this month
    @donations_current_month = @donations.where(occured_on: @start_month..end_month).order(occured_on: :asc)
    # creer un hash dont 'key' sera 1 jour du mois (ex: Thu, 27, Jun 2024), et la 'value' sera un array d'instances de dons qui auront la meme "occured_on"
    @donations_per_day_current_month = @donations_current_month.group_by { |don| don.occured_on.to_date }
    # creer un array avec jour du mois (key) en numéro de jour (ex 27) et la 'value' egale à la somme des 'ammout' des dons dans l'array de dons précédent
    @revenue_per_day_current_month = @donations_per_day_current_month.map { |date, dons| [date.strftime('%d'), dons.sum(&:amount_net)] }
    # The &: syntax is shorthand for converting a symbol to a proc (a block of code). It is equivalent to "dons.sum { |don| don.amount }"
    # if is necessary for the case where no donation occured on a day. This would led to the absence of this day in the above revenue array.
    if @revenue_per_day_current_month.length < @current_month.to_a.length
      # pour pouvoir utiliser la methode 'fetch' plus bas
      revenue_hash = @revenue_per_day_current_month.to_h
      # créer un array de jour du mois complet pour pouvoir le comparer avec @revenue...month et deceler des jours manquants
      @array_complete_days_current_month = @current_month.to_a.map { |day| day.strftime('%d') }
      # pour chaque jour manquant dans revenue, je remplace la indice[1] par 0 => ex [[26,x€], [27, 0]...[30,x€]]
      revenue_complete_days_current_month = @array_complete_days_current_month.map { |day| [day, revenue_hash.fetch(day, 0)] }
      # revenue_complete_days_current_month = @array_complete_days_current_month.map { |day| [day, revenue_hash.fetch(day, 0)] unless day > Date.today.strftime('%d') }
      @revenue_per_day_current_month = revenue_complete_days_current_month.reject { |day| day[0] > Date.today.strftime('%d') }
    end
    # ===== revenue of the current month ===== end
    # ===== connected account balance (available money on the stripe account) ===== start
    @account = Account.find_by(asso: @my_asso)
    if @account
      account_balance = StripeAccount.new(@account).account_balance
      balance_available = account_balance.available.first.amount
      money_pending = account_balance.pending.first.amount
      @balance_future = balance_available + money_pending
      # ===== connected account balance (available money on the stripe account) ===== end

      # @transfers_all = StripeAccount.new(@account).transfers_lifetime
      # @transfers_all_sum = @transfers_all.data.sum(&:amount)
      # tous les transferts y compris les refund toujours inclus dans la somme
      # @transfers_span = StripeAccount.new(@account).transfers_span(@start_month, end_month)
      # @transfers_span_sum = @transfers_span.data.sum(&:amount)
      # tous les transferts hors les refund
      transfers_span = StripeAccount.new(@account).transfers_span(@start_month, end_month).select { |transfer| !transfer.reversed}
      @transfers_span_sum = transfers_span.sum(&:amount)
    end

  end

  def new
    @asso = Asso.new
    @asso.email = current_user.email
  end

  def create
    @asso = Asso.new(asso_params)
    @asso.user = current_user
    if @asso.save
      redirect_to asso_root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def asso_params
    params.require(:asso).permit(:name, :objet, :code_nra, :email, :asso_type_id)
  end
end
