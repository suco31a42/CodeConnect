Rails.application.routes.draw do
  devise_scope :end_user do
    post 'end_users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end
  devise_for :end_users, controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
  }
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
  }
  
  namespace :admin do
    root to: 'end_users#index'
    resources :end_users, only: %i[show edit update] 
    resources :posts, only: %i[index show destroy] do
      resources :post_comments, only: %i[destroy]
    end
  end
  
  scope module: 'public' do
    root to: 'homes#top'
  
    resources :end_users, only: %i[show edit update destroy] do
      member do
        get 'confirm', 'follows', 'followers'
        patch 'withdraw'
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

  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
