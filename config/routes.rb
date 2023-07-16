Rails.application.routes.draw do
  devise_for :end_users
  root to: 'homes#top'

  resources :end_users, only: %i[show edit update destroy] do
    member do
      get 'confirm', 'withdraw', 'follows', 'followers'
    end
    resource :relationships, only: %i[create destroy]

  end
  resources :notifications, only: %i[index] 
  delete :notifications, to: "notifications#destroy_all"

  resources :posts, only: %i[index create show edit update destroy] do
    member do
      delete :delete_image
    end
    collection do
      get 'search'
    end
    get :bookmarks, on: :collection
    resource :likes, only: %i[create destroy]
    resource :bookmarks, only: %i[create destroy]
    resources :post_comments, only: %i[create destroy]
  end
  resources :informations, only: %i[index show]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
