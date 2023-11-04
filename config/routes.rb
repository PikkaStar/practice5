Rails.application.routes.draw do

  devise_for :users
  get root to: 'homes#top'
  get "home/about"=>'homes#about',as: 'about'
  resources :users,only: [:index,:show,:edit,:update] do
    member do
      get :favorite
    end
  end
  resources :books,only: [:create,:index,:show,:edit,:update,:destroy] do
    resource :favorite,only: [:create,:destroy]
    resources :book_comments,only: [:create,:destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
