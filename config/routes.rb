Rails.application.routes.draw do
  resources :users, only: [:index, :show]
  # get '/user/'
  get '/login', to: "users#login_form", as: "login"
  post '/login', to: "users#login"
  # TODO: check if I get the get route for logout, I forgot the method post haha
  post '/logout', to: "users#logout", as: "logout"
  get '/users/current', to: "users#current", as: "current_user"

  #TODO: rails is throwing an error for not having the get path for logout
  # 
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'homepages#index'

  resources :works do
    member do
      post 'upvote'
    end
    # resources :votes, only: [:create]
  end

end
