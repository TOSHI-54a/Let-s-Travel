Rails.application.routes.draw do
  get 'travel_search/index'
  resources :users, only: %i[new create]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :user_sessions, only: %i[new create destroy]
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :users, only: %i[new create show edit update destroy]
  resources :travel_searches, only: %i[new create index]

  # Defines the root path route ("/")
  # root "articles#index"
  root 'static_pages#top'
end

# showのルーティング見直し、resource,id参照を不要にする