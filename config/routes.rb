Rails.application.routes.draw do
  root 'static_pages#top'
  get 'terms', to: 'static_pages#terms'
  get 'contact', to: 'static_pages#contact'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'infomation', to: 'static_pages#infomation'
  post 'first_names/login', to: 'first_names#login'
  post 'share_target_pickers/login', to: 'share_target_pickers#login'
  post 'callback', to: 'line_bot#callback'

  resources :users, only: %i[new create]
  resources :groups, only: %i[new update] do
    resources :first_names, only: %i[index]
    resources :likes, only: %i[index]
  end

  resources :first_names, only: %i[new show destroy] do
    resources :rates, only: %i[new create update edit]
  end

  resources :share_target_pickers, only: %i[new]
  resources :likes, only: %i[create destroy]
end
