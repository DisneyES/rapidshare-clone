Rails.application.routes.draw do
  resources :uploads, only: [:index, :create, :destroy] do
    member do
      get :share
      get :download
    end
  end
  get "files/:id" => "uploads#download", as: :public_download

  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create]

  get '/login' => 'sessions#new'
  root to: 'uploads#index'
end
