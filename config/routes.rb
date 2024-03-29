Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do

      get '/search', to: 'users#search'
      get '/suggestions', to: 'suggestions#index'
      get '/highlights', to: 'users#highlights'
      get '/:username/posts', to: 'users#user_posts', as: :user_posts, constraints: { username: /[^\/]+/ }
      get '/notifications', to: 'users#notifications'
      get '/home', to: 'posts#home'

      resources :posts do
        resources :comments
      end

      get '/reels', to: 'posts#reels'

      post '/posts/:id/like', to: 'posts#like', as: :like
      delete '/posts/:id/like', to: 'posts#unlike', as: :unlike

      post '/posts/:id/comments/:id/like', to: 'comments#like', as: :like_comment
      delete '/posts/:id/comments/:id/like', to: 'comments#unlike', as: :unlike_comment

      get '/users/:id/', to: 'comments#comment_user', as: :comment_user

      resources :users 
    end
  end
  
  get 'users/index'
  scope :api do
    scope :v1 do
      devise_for :users,
                 path: 'auth',
                 path_names: {
                   sign_in: 'login',
                   sign_out: 'logout',
                   registration: 'signup'
                 },
                 controllers: {
                   registrations: 'api/v1/registrations',
                   sessions: 'api/v1/sessions',
                 }, defaults: { format: :json }
      devise_scope :user do
        get '/auth/me', to: 'api/v1/users#me', as: :user_root
        get '/auth/users', to: 'api/v1/users#index', as: :users
        get '/auth/users/:id', to: 'api/v1/users#show', as: :user
        get '/users/show/:username', to: 'api/v1/users#show_by_username', as: :show_by_username, constraints: { username: /[^\/]+/ }
        get '/users/:id/posts', to: 'api/v1/users#user_posts', as: :user_posts
        put '/auth/edit', to: 'api/v1/users#update', as: :update_user
        delete '/auth/users', to: 'api/v1/users#destroy', as: :destroy_user
        post 'password/forgot', to: 'api/v1/password#forgot'
        post 'password/reset', to: 'api/v1/password#reset'
        post '/users/:id/follow', to: 'api/v1/users#follow', as: :follow_user
        delete '/users/:id/unfollow', to: 'api/v1/users#unfollow', as: :unfollow_user
        get '/users/:id/followings', to: 'api/v1/users#following', as: :following_user
        get '/users/:id/followers', to: 'api/v1/users#followers', as: :followers_user
        put '/me/posts/:id', to: 'api/v1/posts#update', as: :update_user_post
        delete '/me/posts/:id', to: 'api/v1/posts#destroy', as: :destroy_user_post
      end
    end
  end
end
