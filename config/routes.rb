Rails.application.routes.draw do
  get 'groups/new'
  root 'static_pages#top'
  get 'login', to: 'users#login'
  get 'first_names/login', to: 'first_names#login'
  post 'first_names/login', to: 'first_names#login'
  post 'callback', to: 'line_bot#callback'

  resources :users, only: [:new, :create]
  resources :groups, only: [:new, :update] do
    resources :first_names, only: [:index, :show, :update, :destroy]
  end
  resources :share_target_pickers, only: [:new]
end
