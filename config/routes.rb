Codes::Application.routes.draw do

  root 'codes#index'

  get '/pm' => redirect('/pm/inbox.html')
  get '/pm/:action', to: 'private_messages#:action', constraints: {action: /(?:out|in)box/i }
  get '/pm/:type/:id', to: 'private_messages#show', constraints: {type: /(?:out|in)box/i }
  resources :private_messages, path: 'pm'

  get '/codes/find_by_user/:user_id', to: 'codes#find_all_by_user_id', constraints: { user_id:/\d+/ }
  get '/codes/:path/:file' => redirect('/codes/%{file}'), constraints: { path: /[a-z0-9]+/i, file: /.*\.(?:cs|j)s/i }
  get 'users', to: 'users#index'
  get 'user/:id', to: 'users#show', constraints: {id:/\d+/}
  delete '/codes/delete/:id', to: 'codes#destroy'
  match 'user/profile', to: 'users#profile', as: 'profile', via: [:get, :patch]
  
  devise_for :users, path: 'user', path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      sign_up: 'register',
      password: 'secret',
      confirmation: 'verification',
      unlock: 'unblock',
      registration: ''
  }

  resources :attachments

  get '/language/:language', to: 'codes#language'

  resources :codes
end