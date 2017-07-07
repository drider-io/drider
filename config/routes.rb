require 'sidekiq/web'
require 'sidekiq/web'
Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  ActiveAdmin.routes(self)

  get "/chat" => "socket#chat", as: "chat"

  mount Facebook::Messenger::Server, at: 'bot'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  get '/welcome' => 'welcome#index', as: :welcome
  get '/policy' => 'welcome#policy', as: :policy
  get '/profile_picture/:id' => 'welcome#profile_picture', as: :profile_picture

  root 'welcome#entry'
  post :mail , controller: :welcome

  namespace :api do
      resources :log, only: [:create]
    resource :token, only: [] do
      post :gcm
      post :apns
      post :facebook
    end
  end

  namespace :users do
    resources :logins, only: [:new]
  end

  scope "/lviv" do
    # resources :car_searches, only: [ :index, :new, :create, :show, :update ]
    get :events, controller: :welcome
  end

  resources :car_routes, only: [ :index, :show, :update, :destroy ]
  # resources :car_requests, only: [ :index, :create, :update, :show ]
  # resources :car_sessions, only: [ :show ]
  # resources :passenger_search
  # resources :messages, only: [ :index, :show, :create ]

  authenticate :user, lambda { |u| u.is_admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resource :download, only: [:show] do
    get :android, to: redirect('https://play.google.com/store/apps/details?id=io.drider.car&utm_source=global_co&utm_medium=prtnr&utm_content=Mar2515&utm_campaign=PartBadge&pcampaignid=MKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1')
    get :ios, to: redirect('https://itunes.apple.com/ua/app/drider/id1101420670?ls=1&mt=8')
  end

  resource :account do
    get '/driver_role/:value', action: :driver_role, as: :driver_role
    get :route_required
    get :device_warning
    get :role_select
  end


  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
