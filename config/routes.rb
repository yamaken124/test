Rails.application.routes.draw do

  if Rails.env.development?
    devise_for :users, :controllers => {
      :sessions => 'users/sessions',
      :passwords => "users/passwords",
      :registrations => 'users/registrations'
    }
    devise_for :admins,
      :controllers => { :sessions => 'admins/sessions' }
  else
    devise_for :users,
      :controllers => { :sessions => 'users/sessions' },
      :only => [ :session ]
    devise_for :admins,
      :controllers => { :sessions => 'admins/sessions' },
      :only => [ :session ]
  end

  root 'users/accounts#show'

  resource :health_check, only: [:show]

  scope module: :users do
    namespace :oauth do
      resource :authorization, only: [:create] do
        get '/', action: :create
        post 'sign_in_with_email_password', action: :sign_in_with_email_password
      end
    end
    resource :account, only: [:show] do
      resources :addresses, only: [:index, :edit, :update, :new, :create, :destroy] do
        collection do
          get 'fetch_address_with_zipcode', action: :fetch_address_with_zipcode, :as => :fetch_address
        end
      end
    end
    resource :profile, only: [:edit, :create, :update] do
      resources :credit_cards, only: [:index, :new, :edit, :create, :destroy]
    end
    resources :products, only: [:index, :show] do
      collection do
        get ':id/show_one_click/', action: :show_one_click, :as => :show_one_click
        get ':id/description', action: :description, :as => :description
        get 'update_max_used_point', action: :update_max_used_point, :as => :update_max_used_point
      end
    end
    resource :cart, only: [:update], controller: :orders do
      get '/', action: :edit
      get :address, on: :member
      patch '/remove_item/:id' => 'orders#remove_item', on: :collection, :as => :remove_item
    end
    resources :orders, only: [:index, :show] do
      collection do
        post :populate
        post :one_click_item
        get  ':number/thanks', action: :thanks, :as => :thanks
        get  ':number/one_click_thanks', action: :one_click_thanks, :as => :one_click_thanks
        delete '/cancel/:number' => 'orders#cancel', :as => :cancel
      end
    end
    namespace :orders do
      resources :items, only: [] do
        get  'send_back_confirmation'
        post 'request_send_back'
      end
    end

    get '/checkout/:state', :to => 'checkouts#edit', :as => :checkout_state
    patch '/checkout/:state', :to => 'checkouts#update', :as => :update_checkout
    get '/t/*id', :to => 'taxons#show', :as => :taxons #nested_taxon
    get '/guidances/:name', :to => 'guidances#show', :as => :guidance
  end

  namespace :admins do
    resources :products do
      resources :variants, only: [:index, :new, :create, :edit, :update, :destroy]
    end
    resources :variants, only: [] do
      resources :images,only: [:index, :new, :create, :edit, :update, :destroy], controller: :images, imageable_type: 'Variant'
      post '/images/sort', :to => 'images#sort'
    end
    namespace :shipments do
      resources :singles, only:[:index, :show, :update] do
        collection do
          get 'state/:state', :to => 'singles#index', :as => :state
          get 'return_requests'
          get 'shipment_details'
          get 'csv_export'
          patch 'update_tracking_code', :to => 'singles#update_tracking_code', :as => :update_tracking_code
          patch 'update_state', :to => 'singles#update_state', :as => :update_state
        end
        member do
        end
      end
      resources :one_clicks, only:[:index, :show, :update] do
        collection do
          get 'state/:state', :to => 'one_clicks#index', :as => :state
          get 'return_requests'
          get 'shipment_details'
          get 'csv_export'
          patch 'update_tracking_code', :to => 'one_clicks#update_tracking_code', :as => :update_tracking_code
          patch 'update_state', :to => 'one_clicks#update_state', :as => :update_state
        end
      end
    end
    #TODO routing setting
    namespace :bills do
      resources :credits
      resources :post_payments
      resources :subscriptions
      resources :one_clicks
    end
    resources :users, only:[:index, :show, :update] do
      collection do
        post 'search'
      end
    end
  end

end
