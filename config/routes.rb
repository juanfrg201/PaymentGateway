Rails.application.routes.draw do
  resources :payu, only: [] do
    collection do
      post :confirmation
      get :response
    end
  end
  resources :charges, only: [:new, :create] do
    collection do
      get :payu
    end
  end
  root 'homa_page#index'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
