Rails.application.routes.draw do
  root 'jobs#index'
  devise_for :users, :controllers => 
                      { omniauth_callbacks: "omniauth/omniauth_callbacks" }

  resources :jobs, only: [:index, :show] do
    get 'search', on: :collection
    get 'distance', on: :collection
  end

  get 'posts' => 'posts#index', as: "posts_index"
  scope 'user/:user_name.:user_id' do
    resources :posts, only: [:show, :create, :update, :destroy, :edit] do
      resources :comments, only: [:create, :update, :edit, :destroy]
    end
    post 'request_friend', controller: 'users'
    post 'cancel_request', controller: 'users'
    post 'accept_friend', controller: 'users'
    post 'remove_friend', controller: 'users'
    delete 'destroy', controller: 'users'
  end


  # User
  get '/admin' => "users#index", as: :admin_users
  get '/user/:user_name.:user_id' => "users#show", as: :user_profile

  # google verification
  get '/google6cd96f3e20442b00.html' => 'google_verification#index'

end
