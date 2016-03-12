Rails.application.routes.draw do
  get 'pages/home'

  get 'pages/home'
  root 'pages#home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  resources :contacts, only: :index, defaults: {format: :json}
  resources :positions, only: :index, defaults: {format: :json}
end