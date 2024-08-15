class Assos::SignaturesController < AssosController
  def new
    @asso = current_user.asso
  end

  def create
    raise
    puts '✅✅✅✅✅✅'
  end

  def update
  end
end
