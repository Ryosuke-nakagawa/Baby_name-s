Rails.application.routes.draw do
  root 'static_pages#top'
  post 'first_names/login', to: 'first_names#login'
  post 'share_target_pickers/login', to: 'share_target_pickers#login'
  post 'callback', to: 'line_bot#callback'

  resources :users, only: [:new, :create]
  resources :groups, only: [:new, :update] do
    resources :first_names, only: [:index, :show, :update, :destroy, :edit]
  end
  resources :rates, only: [:create, :update]
  resources :first_names, only: [:new]
  resources :share_target_pickers, only: [:new]
end
