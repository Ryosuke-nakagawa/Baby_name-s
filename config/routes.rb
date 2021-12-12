Rails.application.routes.draw do
  get 'groups/new'
  root 'static_pages#top'
  get 'login', to: 'users#login'
  post 'callback', to: 'line_bot#callback'

  resources :users, only: [:new, :create]
  resources :groups, only: [:new, :update]
  resources :share_target_pickers, only: [:new]
end
