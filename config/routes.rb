Rails.application.routes.draw do
  devise_for :users, :controllers => { omniauth_callbacks: "omniauth/omniauth_callbacks" }

  root 'jobs#index'

  get '/:user_name(.:id)' => "users#show", as: :user_profile
  post '/admin/:user_name(.:id)' => "users#index", as: :admin_users
  post '/request/:user_name(.:id)' => "users#request_friend", as: :request_friend
  post '/cancel_request/:user_name(.:id)' => "users#cancel_request", as: :cancel_request
  post '/accept/:user_name(.:id)' => "users#accept_friend", as: :accept_friend
  post '/remove/:user_name(.:id)' => "users#remove_friend", as: :remove_friend
end
