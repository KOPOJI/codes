CodesApp::Application.routes.draw do

  %w( 404 422 500 503 ).each do |code|
    get code, :to => 'errors#show', :code => code
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'


  locales = I18n.available_locales.join('|')

  scope '(:locale)', locale: /#{locales}/i, constraints: {format: 'html'}, defaults: {format: 'html'} do

    root 'codes#index'

    match '/codes/delete_interval', to: 'codes#delete_interval', via: [:get, :post], format: 'html'
    match '/codes/search', to: 'codes#search', via: [:get, :post], format: 'html'

    get '/pm' => redirect('/pm/inbox.html')
    get '/pm/:action', to: 'private_messages#:action', constraints: {action: /(?:out|in)box/i }, format: 'html'
    get '/pm/:type/:id', to: 'private_messages#show', constraints: {type: /(?:out|in)box/i }, format: 'html'
    resources :private_messages, path: 'pm', format: 'html'

    get '/codes/find_by_user/:user_id', to: 'codes#find_all_by_user_id', constraints: { user_id:/\d+/ }, format: 'html'
    get '/codes/:path/:file' => redirect('/codes/%{file}'), constraints: { path: /[a-z0-9]+/i, file: /.*\.(?:cs|j)s/i }, format: 'html'
    get '/users', to: 'users#index', format: 'html'
    get '/user/:id', to: 'users#show', constraints: {id:/\d+/}, format: 'html'
    get '/codes/show_delete_links', to: 'codes#delete_links', format: 'html'
    delete '/codes/delete/:id', to: 'codes#destroy', format: 'html'
    match '/user/profile', to: 'users#profile', as: 'profile', via: [:get, :patch], format: 'html'

    devise_for :users, path: 'user', alias: 'users', format: 'html', path_names: {
        sign_in: 'login',
        sign_out: 'logout',
        sign_up: 'register',
        password: 'secret',
        confirmation: 'verification',
        unlock: 'unblock',
        registrations: 'register'
    }
    #, controllers: { registrations: 'registrations' }

    resources :codes, :attachments, format: 'html'

  end
end