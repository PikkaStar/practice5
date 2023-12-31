Rails.application.routes.draw do
  devise_for :users
  get root to: "homes#top"
  get "home/about" => "homes#about", as: "about"
  resources :users, only: [:index, :show, :edit, :update] do
    resources :notifications, only: [:index] do
    post :update_checked, on: :collection
     end
    resource :relationships, only: [:create, :destroy]
    get "followings" => "relationships#followings", as: "followings"
    get "followers" => "relationships#followers", as: "followers"
    member do
      get :groups, as: "group"
      get :favorite
    end
  end
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end
  resources :books, only: [:create, :index, :show, :edit, :update, :destroy] do
    resource :favorite, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  get "searches" => "searches#search", as: "search"
  resources :messages, only: [:create]
  resources :rooms, only: [:create, :show, :index]
  resources :groups do
    get "groups/:id/messages" => "groups#messages", as: "message"
    resource :permits, only: [:create, :destroy]
    resource :group_users, only: [:create, :destroy]
  end
  get "groups/:id/permits" => "groups#permits", as: :permits
  get "search_tag" => "books#search_tag"
  get "search_genre" => "groups#search_genre"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
