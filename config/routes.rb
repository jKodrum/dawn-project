Rails.application.routes.draw do
  root 'jobs#index'
  devise_for :users, :controllers => 
                      { omniauth_callbacks: "omniauth/omniauth_callbacks" }

  resources :jobs, only: [:index, :show] do
    get 'search', on: :collection
  end

  scope 'user/:user_name(.:user_id)' do
    resources :posts, only: [:create, :update, :destroy, :edit]
    post 'request_friend', controller: 'users'
    post 'cancel_request', controller: 'users'
    post 'accept_friend', controller: 'users'
    post 'remove_friend', controller: 'users'
    delete 'destroy', controller: 'users'
  end


  # User
  get '/admin' => "users#index", as: :admin_users
  get '/user/:user_name(.:user_id)' => "users#show", as: :user_profile

end
