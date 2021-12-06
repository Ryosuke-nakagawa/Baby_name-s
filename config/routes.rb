Rails.application.routes.draw do
  root 'static_pages#top'
  get 'login', to: 'users#login'

  resources :users, only: [:new, :create]

end
