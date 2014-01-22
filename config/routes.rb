require 'icecast_constraints'

Radioxide::Application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users

  apipie

  namespace :api do
    scope '1' do
      resources :stations, except: [:new, :edit] do
        member do
          patch :suggest
        end
        collection do
          get :local,                   to: 'stations_search#local',    as: :local
          get 'country/:country_code',  to: 'stations_search#country',  as: :country
          get 'language/:language',     to: 'stations_search#language', as: :language
          get 'genre/:genres',          to: 'stations_search#genre',    as: :genre
          get 'search/',                to: 'stations_search#search',   as: :search
        end
      end

      resources :contributions, except: [:new, :edit, :show] do
        collection do
          get :on_my_stations
        end
        member do
          post :apply
        end
      end

      resources :genres, only: :index do
        collection do
          get :popular
        end
      end

      namespace :user do
        resources :registrations, only: [:create, :destroy]
        resources :sessions, only: [:create, :show, :destroy]
        resources :confirmations, only: [:create]
        resources :passwords, only: [:create]
      end

      # Icecast YP compatibility
      # this is kinda ugly since icecast use the reserver 'action' parameter :-/
      post '/icecast' => 'icecast#add', as: :icecast_add,
        constraints: IcecastConstraints::Add
      post '/icecast' => 'icecast#touch', as: :icecast_touch,
        constraints: IcecastConstraints::Touch
      post '/icecast' => 'icecast#remove', as: :icecast_remove,
        constraints: IcecastConstraints::Remove
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

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
