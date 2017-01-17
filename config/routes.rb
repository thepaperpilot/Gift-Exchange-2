Rails.application.routes.draw do
  get 'sessions/new'

  get 'users/new'

  get 'welcome/index'

  resources :group, param: :code, only: [:show, :create, :update, :destroy] do
    resources :people, only: [:create, :update, :destroy]
    resources :rules, only: [:create, :update, :destroy] do
      resources :tokens, only: [:create, :update, :destroy]
    end
  end

  resources :users

  root 'welcome#index'

  get     '/group/:code/admin',     to: 'group#show'
  get     '/signup',                to: 'users#new'
  get     '/login',                 to: 'sessions#new'
  post    '/',                      to: 'group#create'
  post    '/search',                to: 'group#search'
  post    '/group/:code/admin',     to: 'group#admin',      as: 'admin'
  post    '/group/:code/generate',  to: 'group#randomize',  as: 'generate'
  post    '/group/:code/clear',     to: 'group#clear',      as: 'clear'
  post    '/signup',                to: 'users#create'
  post    '/login',                 to: 'sessions#create'
  delete  '/logout',                to: 'sessions#destroy'
end
