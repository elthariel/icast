require 'icecast_constraints'

Radioxide::Application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {confirmations: 'confirmations'}
  apipie

  namespace :api do
    match "(*redirect_path)", to: "base#options", via: :options

    scope '1' do
      resources :stations, except: [:new, :edit] do
        member do
          post :suggest
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

  # Any other HTML route request is sent to Angular
  get "(*redirect_path)", to: "angular#index", constraints: lambda { |request| request.format == "text/html" }
  root 'angular#index'
end
