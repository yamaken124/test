Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :sessions => 'users/sessions', 
    :passwords => "users/passwords",
    :registrations => 'users/registrations'
  }

  scope module: :users do
    resource :account, only: [:show]
    resources :products, only: [:index, :show]
    resource :cart, only: [:update], controller: :orders do
      get '/', action: :edit
      get :address, on: :member
    end
    resources :orders, :except => [:new, :create, :destroy] do
      post :populate, :on => :collection
    end

    get '/checkout/:state', :to => 'checkouts#edit', :as => :checkout_state
    patch '/checkout/:state', :to => 'checkouts#update', :as => :update_checkout

    get '/t/*id', :to => 'taxons#show', :as => :nested_taxon
  end

  namespace :admins do
    resources :products, only: [:index, :new, :create]
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
