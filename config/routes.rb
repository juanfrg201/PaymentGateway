Rails.application.routes.draw do
  resources :charges, only: [:new, :create]
  root 'homa_page#index'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
