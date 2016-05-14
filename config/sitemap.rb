# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'https://savecode.ru'

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #

  add '/ru/codes/new.html'
  Code.find_each do |code|
    add "/ru/codes/#{code.id}.html", :lastmod => code.updated_at
  end

  add '/ru/attachments.html'
  add '/ru/attachments/new.html'
  Attachment.find_each do |attach|
    add "/ru/attachments/#{attach.id}.html", :lastmod => attach.updated_at
  end

  add '/ru/users.html'
  add '/ru/user/login.html'
  add '/ru/user/register.html'
  add '/ru/user/secret/new.html'
  User.find_each do |u|
    add "/ru/user/#{u.id}.html", :lastmod => u.updated_at
    add "/ru/codes/find_by_user/#{u.id}.html" , :lastmod => u.updated_at
  end

end
