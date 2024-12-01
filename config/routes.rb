Rails.application.routes.draw do
  get 'qr_codes/new' # is this still useful ?
  get 'qr_codes/create' # is this still useful ?

  devise_for :users

  # Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, ->(user) { user.id == 2 } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # ======== Webhooks ========
  # set the entry point ot handle 3rd parties post requests (stripe, etc...)
  post '/webhooks/:source', to: 'webhooks#create'

  # ======== Pages ========
  # this line sends any user to the landing page
  root to: "pages#landing"

  # after sign in, a method redirect user to appropriate dashboards (donator or asso)
  # ======== assos ========

  # this line sends the user to the asso's dashboard view in views/assos/dashboard.html.erb
  get "/assos", to: "assos#dashboard", as: :asso_root
  resources :assos, only: %i[new create] do
    resources :donations, only: %i[index]
  end

  # this line is to create a portal dedicated to the asso users
  namespace :assos do
    resources :places, only: %i[index show new create destroy]
    resource :signature, only: %i[new create]
    resource :account, only: %i[create show] do
      member do
        get '/stripe', to: 'accounts#account_token' # to retrieve public key client side for stripe js
      end
    end
    resource :payout, only: %i[new create]
    resources :donators, only: %i[index]
    # nest a resources donations only index and show. will work since ctrl is nested in the assos namespace
  end

  # ======== places ========

  # we need a show page of the places for the donators to reach (create fav, see place etc...)
  # this route don't interfer with the one in the asso namespace since it is nested inside asso namespace
  resources :places, only: %i[show] do
    resources :donations, only: %i[new]
    resource :checkout, only: %i[create show]
    get "/qrcode", to: "places#download_qrcode"
    get "/qrcodeattach", to: "places#attach_qrcode"
  end

  # after sign in, a method redirect user to appropriate dashboards (donator or asso)
  # ======== donator ========

  # this line sends the user to the donator's dashboard view in views/assos/dashboard.html.erb
  # a before action to authenticate user is expected in the controller "donators"
  # a after_create in user model, create also a donator if role was set as donator by user
  get "/donator", to: "donators#dashboard", as: :donator_root

  resources :donators, only: %i[new create] do
    resources :favorites, only: %i[create destroy]
    resources :donations, only: %i[index] do
      member do
        get 'pdf', to: 'pdfs#generate', as: :pdf_generate
        # get 'cerfa', to: 'pdfs#view_pdf'
        # get 'cerfa_inline', to: 'pdfs#cerfa_inline'
        get 'download', to: 'pdfs#download_pdf'
      end
    end
  end

  # to collect feedback from donators after each donation paiement
  resources :reviews, only: %i[create]


end
