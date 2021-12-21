Rails.application.routes.draw do
  root 'static_pages#top'
  post 'first_names/login', to: 'first_names#login'
  post 'share_target_pickers/login', to: 'share_target_pickers#login'
  post 'callback', to: 'line_bot#callback'

  resources :users, only: %i[new create]
  resources :groups, only: %i[new update] do
    resources :first_names, only: %i[index]
  end

  resources :first_names, only: %i[new show destroy] do
    resources :rates, only: %i[new create update edit]
  end

  resources :share_target_pickers, only: %i[new]
end
