Rails.application.routes.draw do
  get 'qr_codes/new' # is this still useful ?
  get 'qr_codes/create' # is this still useful ?

  devise_for :users

  # ======== Pages ========
  # this line sends any user to the landing page
  root to: "pages#landing"

  # after sign in, a method redirect user to appropriate dashboards (donator or asso)
  # ======== assos ========

  # this line sends the user to the asso's dashboard view in views/assos/dashboard.html.erb
  get "/assos", to: "assos#dashboard", as: :asso_root
  resources :assos, only: %i[new create]

  # this line is to create a portal dedicated to the asso users
  namespace :assos do
    resources :places, only: %i[index show new create destroy]
  end

  # ======== places ========

  # we need a show page of the places for the donators to reach (create fav, see place etc...)
  # this route don't interfer with the one in the asso namespace since it is nested inside asso namespace
  resources :places, only: %i[show]

  # after sign in, a method redirect user to appropriate dashboards (donator or asso)
  # ======== donator ========

  # this line sends the user to the donator's dashboard view in views/assos/dashboard.html.erb
  # a before action to authenticate user is expected in the controller "donators"
  # a after_create in user model, create also a donator if role was set as donator by user
  get "/donator", to: "donators#dashboard", as: :donator_root

  resources :donators, only: %i[new create] do
    resources :favorites, only: %i[new create]
  end

end
