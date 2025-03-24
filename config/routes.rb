Rails.application.routes.draw do
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
  get "/members", to: "pages#members" # feature in working (static)
  get '/tools', to: 'pages#tools' # feature in working (static)
  # get '/profil', to: 'pages#profil' # choisir entre asso ou donator signup form (cf helloasso)

  # after sign in, a method redirect user to appropriate dashboards (donator or asso)
  # ======== assos ========

  # this line sends the user to the asso's dashboard view in views/assos/dashboard.html.erb
  get "/assos", to: "assos#dashboard", as: :asso_root
  resources :assos, only: %i[new create] do
    resources :donations, only: %i[index]
  end

  # this line is to create a portal dedicated to the asso users
  namespace :assos do
    resources :places, only: %i[index show new create edit update destroy] do
      resources :donations, only: %i[new create destroy] # manu cerfa tool
      # resources :volunteerings, only: %i[index new create edit update] # form pour asso afin de créer un bénévolat
    end
    resource :signature, only: %i[new create]
    resource :account, only: %i[create show] do
      member do
        get '/stripe', to: 'accounts#account_token' # to retrieve public key client side for stripe js
      end
    end
    resource :payout, only: %i[new create]
    resources :donators, only: %i[index]
    # resources :volunteerings, only: %i[index new create edit update] # form pour asso afin de créer un bénévolat
  end

  # ======== places ========

  # we need a show page of the places for the donators to reach (create fav, see place etc...)
  # this route don't interfer with the one in the asso namespace since it is nested inside asso namespace
  resources :places, only: %i[show] do
    resources :donations, only: %i[new edit update] do
      member do
        get 'success', to: 'donations#successful'
      end
    end
    resource :checkout, only: %i[create show]
  end

  # after sign in, a method redirect user to appropriate dashboards (donator or asso)
  # ======== donator ========

  # this line sends the user to the donator's dashboard view in views/assos/dashboard.html.erb
  # a before action to authenticate user is expected in the controller "donators"
  # a after_create in user model, create also a donator if role was set as donator by user
  get "/donator", to: "donators#dashboard", as: :donator_root

  resources :donators, only: %i[edit update] do
    resources :volunteerings, only: %i[index destroy], shallow: true
    resources :favorites, only: %i[create destroy]
    resources :donations, only: %i[index] do
      member do
        post 'pdf', to: 'pdfs#generate', as: :pdf_generate
        get 'download', to: 'pdfs#download_pdf'
        get 'cerfa', to: 'pdfs#view_pdf'
      end
    end
    # resources :volunteerings, only: %i[index new create destroy] # form pour donator afin de créer un bénévolat en passant la place id depuis la place#show
  end


  # to collect feedback from donators after each donation paiement
  resources :reviews, only: %i[create]
end
