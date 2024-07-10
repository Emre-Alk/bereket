Rails.application.routes.draw do
  get 'qr_codes/new' # is this still useful ?
  get 'qr_codes/create' # is this still useful ?

  devise_for :users

  # this line sends any user to the landing page
  root to: "pages#landing"

  # after sign in, a method redirect user to appropriate dashboards (donator or asso)

  # --------------assos--------------
  # this line sends the user to the asso's dashboard view in views/assos/dashboard.html.erb
  get "/assos", to: "assos#dashboard", as: :asso_root

  # this line is to create a portal dedicated to the asso users

  namespace :assos do
    resources :places, only: %i[index show new create destroy]
  end

  resources :assos, only: %i[new create]

  # -----------------donator------------
  # this line sends the user to the donator's dashboard view in views/assos/dashboard.html.erb
  # a before action to authenticate user is expected in the controler "donators"
  get "/donator", to: "donators#dashboard", as: :donator_root

  resources :donators, only: %i[new create]

  # ----------------- donations ------------

end
