Rails.application.routes.draw do
  resources :users, only: %i[new create]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :user_sessions, only: %i[new create destroy]
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :users, only: %i[new create show edit destroy]

  # Defines the root path route ("/")
  # root "articles#index"
  root 'static_pages#top'
end
