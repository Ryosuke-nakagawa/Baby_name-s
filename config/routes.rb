Rails.application.routes.draw do
  root 'static_pages#top'
  get 'terms', to: 'static_pages#terms'
  get 'contact', to: 'static_pages#contact'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'infomation', to: 'static_pages#infomation'
  post 'first_names/login', to: 'first_names#login'
  post 'share_target_pickers/login', to: 'share_target_pickers#login'
  post 'callback', to: 'line_bot#callback'
  get '/sitemap', to: redirect("https://s3-ap-northeast-1.amazonaws.com/#{ENV['AWS_BUCKET']}/sitemap.xml.gz")
  resources :users, only: %i[new create destroy]
  resources :groups, only: %i[new update] do
    resources :first_names, only: %i[index]
  end

  resources :first_names, only: %i[new show destroy] do
    resources :rates, only: %i[new create]
    resources :comments, only: %i[create update destroy], shallow: true
    collection do
      get :likes
    end
  end
  resources :rates, only: %i[update]
  resources :share_target_pickers, only: %i[new]
  resources :likes, only: %i[create destroy]
  resources :rankings, only: %i[index]

  namespace :admin do
    root to: 'dashboards#top'
    get 'login', to: 'user_sessions#new'
    post 'login', to: 'user_sessions#login'
    delete 'logout', to: 'user_sessions#logout'
    resources :first_names, only: %i[index show edit destroy update]
    resources :users, only: %i[index show edit destroy update]
  end
end
