Rails.application.routes.draw do
  devise_for :end_users
  root to: 'homes#top'
  
  resources :end_users, only: %i[show edit update destroy] do
    member do
      get 'confirm', 'withdraw', 'follows', 'followers'
    end
    resources :relationships, only: %i[create destroy]
    resources :bookmarks, only: %i[index]
    resources :notifications, only: %i[index]
  end
  
  resources :posts, only: %i[index create edit update destroy] do
    resources :likes, only: %i[create destroy]
    resources :bookmarks, only: %i[create destroy]
    resources :post_comments, only: %i[create destroy]
  end
  
  resources :informations, only: %i[index show]
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
