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
          get  'fetch_address_with_zipcode', action: :fetch_address_with_zipcode, :as => :fetch_address
        end
      end
    end
    resource :profile, only: [:edit, :create, :update] do
      resources :credit_cards, only: [:index, :new, :edit, :create, :destroy]
    end
    resources :products, only: [:index, :show]
    resource :cart, only: [:update], controller: :orders do
      get '/', action: :edit
      get :address, on: :member
      patch '/remove_item/:id' => 'orders#remove_item', on: :collection, :as => :remove_item
    end
    resources :orders, only: [:index, :show] do
      collection do
        post :populate
        get  ':number/thanks', action: :thanks, :as => :thanks
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
    end
    resources :shipments, only:[:index, :show, :update] do
      collection do
        get 'state/:state', :to => 'shipments#index', :as => :state
        get 'return_requests'
        get 'shipment_details'
        patch 'update_tracking_code', :to => 'shipments#update_tracking_code', :as => :update_tracking_code
        patch 'update_state', :to => 'shipments#update_state', :as => :update_state
      end
      member do
      end
    end
    #TODO routing setting
    namespace :bills do
      resources :credits
      resources :post_payments
      resources :subscriptions
    end
  end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
