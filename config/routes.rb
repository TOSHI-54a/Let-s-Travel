# frozen_string_literal: true

Rails.application.routes.draw do
  post 'google_login_api/callback'
  get 'savings/new'
  get 'savings/create'
  get 'savings/index'
  get 'savings/show'
  get 'savings/edit'
  get 'savings/update'
  get 'savings/destroy'
  get 'travel_search/index'
  resources :users, only: %i[new create]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :user_sessions, only: %i[new create destroy]
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :users, only: %i[new create show edit update destroy]
  resources :travel_searches, only: %i[new create index]
  resources :boards, only: %i[index show new create edit update destroy] do
    resources :comments, only: %i[create edit update destroy], shallow: true
  end
  resources :savings

  # Defines the root path route ("/")
  # root "articles#index"
  root 'static_pages#top'
end

# showのルーティング見直し、resource,id参照を不要にする
