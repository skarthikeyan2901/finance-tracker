Rails.application.routes.draw do
  resources :user_stocks, only: [:create, :destroy]
  devise_for :users
  root 'welcome#index'
  get 'my_portfolio', to: 'users#my_portfolio'
  get 'my_friends', to: 'users#my_friends'
  get 'search_stock', to: 'stocks#search', defaults: { format: 'js' }
  get 'search_user', to: 'users#search_users', defaults: { format: 'js' }
  resources :stocks, only: [:show]
  resources :friendships, only: [:create, :destroy]
  resources :users, only: [:show]
  get 'get_change', to: 'stocks#get_change', defaults: { format: 'js' }
  get 'get_open_price', to: 'stocks#get_open_price', defaults: { format: 'js' }
  get 'get_close_price', to: 'stocks#get_close_price', defaults: { format: 'js' }
  get 'get_volume', to: 'stocks#get_volume', defaults: { format: 'js' }
  get 'get_ytdchange', to: 'stocks#get_ytdchange', defaults: { format: 'js' }
end
