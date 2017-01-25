Rails.application.routes.draw do
  resources :uploads, only: [:index, :create, :destroy] do
    member do
      get :share
      get :download
    end
  end
  get "files/:id" => "uploads#download", as: :public_download

  resources :sessions, only: [:create]
  resources :users, only: [:new, :create]

  get '/login' => 'sessions#new'
  delete '/logout' => 'sessions#destroy'

  root to: 'uploads#index'
end
