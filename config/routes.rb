Rails.application.routes.draw do
  resources :uploads, only: [:index, :create, :destroy] do
    get :share, on: :member
  end
  get "uploads/:id/:file_name" => "uploads#download", as: :download_uploaded_file
  get "files/:id" => "uploads#download", as: :public_download

  resources :sessions, only: [:create]
  resources :users, only: [:new, :create]

  get '/login' => 'sessions#new'
  delete '/logout' => 'sessions#destroy'


  root to: 'uploads#index'
end
