Rails.application.routes.draw do
  get 'welcome/index'

  resources :group, param: :code, only: [:show, :create, :update, :destroy] do
    resources :people, only: [:create, :update, :destroy]
    resources :rules, only: [:create, :update, :destroy] do
      resources :tokens, only: [:create, :update, :destroy]
    end
  end

  root 'welcome#index'

  post 'search' => 'group#search'
  post '/' => 'group#create'
  post '/group/:code/admin', to: 'group#admin', as: 'admin'
  post '/group/:code/generate', to: 'group#randomize', as: 'generate'
  post '/group/:code/clear', to: 'group#clear', as: 'clear'
  get '/group/:code/admin', to: 'group#show'
end
