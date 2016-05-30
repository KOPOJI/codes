CodesApp::Application.routes.draw do

  %w( 404 422 500 503 ).each do |code|
    get code, :to => 'errors#show', :code => code
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

=begin
  locales = I18n.available_locales.join('|')

  root to: redirect("/#{I18n.default_locale}/", status: 301), as: :redirected_root
  get '/codes' => redirect("/#{I18n.default_locale}/", status: 301)

  get '/codes/:id' => redirect('/ru/codes/%{id}.html', status: 301)
  get '/codes/:id/edit' => redirect('/ru/codes/%{id}/edit.html', status: 301)
  get '/attachments/:id' => redirect('/ru/attachments/%{id}.html', status: 301)
  get '/attachments' => redirect('/ru/attachments.html', status: 301)
  get '/attachments/:id/edit' => redirect('/ru/attachments/%{id}/edit.html', status: 301)

  get '*path' => redirect { |params, req|
    return "#{req.path}/?page=#{req.query_parameters[:page]}" if (req.path =~ /^\/?(?:#{locales})$/i) && req.query_parameters[:page].present?
    req.query_parameters[:page].present? ? "#{req.path}.html?page=#{req.query_parameters[:page]}" : "#{req.path}.html"
  }, constraints: lambda {
      |req| !(req.path =~ /^\/?(?:#{locales})\/?$/i) && !(req.path =~ /\.(?:html?|xml|s?css|js|jpe?g|png|gif)/i)
  }, status: 301
=end

  scope '(:locale)', locale: /#{locales}/i do

    root 'codes#index'

    match '/codes/delete_interval', to: 'codes#delete_interval', via: [:get, :post], format: 'html'

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

    devise_for :users, path: 'user', format: 'html', path_names: {
        sign_in: 'login',
        sign_out: 'logout',
        sign_up: 'register',
        password: 'secret',
        confirmation: 'verification',
        unlock: 'unblock',
        registration: ''
    }

    resources :codes, :attachments, format: 'html'

  end
end