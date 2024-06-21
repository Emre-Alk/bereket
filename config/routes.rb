Rails.application.routes.draw do
  devise_for :users

  # this line sends any user to the landing page
  root to: "pages#landing"

  # --------------assos--------------
  # this line sends the user to the asso's dashboard view in views/assos/dashboard.html.erb
  # a before action to authenticate user is expected in the controler "assos"
  get "/assos", to: "assos#dashboard", as: :asso_root

  # this line is to create a portal dedicated to the asso users
  namespace :assos do
    resources :places, only: %i[index show new create]
  end

  # -----------------donator------------
  # this line sends the user to the donator's dashboard view in views/assos/dashboard.html.erb
  # a before action to authenticate user is expected in the controler "donators"
  get "/donator", to: "donators#dashboard", as: :donator_root
end
