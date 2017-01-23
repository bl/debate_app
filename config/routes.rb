Rails.application.routes.draw do
  resources :topics do
    resources :debates, only: [:new, :create, :index]
  end

  resources :debates, only: [:show, :update, :edit, :destroy] do
      resources :messages, only: [:new, :create, :index]
  end

  resources :messages, only: [:show, :update, :edit, :destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
