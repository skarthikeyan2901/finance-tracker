Rails.application.routes.draw do
  resources :messages
  resources :user_stocks, only: [:create, :destroy]
  devise_for :users
  root 'welcome#index'
  get 'my_portfolio', to: 'users#my_portfolio'
  get 'my_friends', to: 'users#my_friends'
  get 'search_stock', to: 'stocks#search', defaults: { format: 'js' }
  get 'search_user', to: 'users#search_users', defaults: { format: 'js' }
  resources :friendships, only: [:create, :destroy]
  resources :users, only: [:show]
  get 'get_change', to: 'stocks#get_change', defaults: { format: 'js' }

  resources :stocks, only: [:show] do
    collection do
      get :forum
      get :forum_submit, defaults: { format: 'js' }
      get :refresh_prices, defaults: { format: 'js' }
    end
  end
end
