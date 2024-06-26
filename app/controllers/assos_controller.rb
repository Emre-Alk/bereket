class AssosController < ApplicationController
  before_action :authenticate_user!
  before_action :is_asso?

  def dashboard
    @my_asso = current_user.asso
    @my_place = @my_asso.places.first # "first" afin de faire simple pour l'exemple mais reprendre pour carousselle
    @donations = @my_place.donations
    @table = @donations.map { |i| [i.donator.id, i.amount] }
    @sum = 0
    @table.each do |e|
      @sum += e[1]
    end
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
