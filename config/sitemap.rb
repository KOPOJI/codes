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

  add '/ru/codes/new.html', alternate: {href: '/en/codes/new.html', lang: :en}
  Code.find_each do |code|
    add "/ru/codes/#{code.id}.html", lastmod: code.updated_at, alternate: {href: "/en/codes/#{code.id}.html", lang: :en}
  end

  add '/ru/attachments.html', alternate: {href: '/en/attachments.html', lang: :en}
  add '/ru/attachments/new.html', alternate: {href: '/en/attachments/new.html', lang: :en}
  Attachment.find_each do |attach|
    add "/ru/attachments/#{attach.id}.html", lastmod: attach.updated_at, alternate: {href: "/en/attachments/#{attach.id}.html", lang: :en}
  end

  add '/ru/users.html', alternate: {href: '/en/users.html', lang: :en}
  add '/ru/user/login.html', alternate: {href: '/en/users/login.html', lang: :en}
  add '/ru/user/register.html', alternate: {href: '/en/user/register.html', lang: :en}
  add '/ru/user/secret/new.html', alternate: {href: '/en/user/secret/new.html', lang: :en}
  User.find_each do |u|
    add "/ru/user/#{u.id}.html", lastmod: u.updated_at, alternate: {href: "/en/user/#{u.id}.html", lang: :en}
    add "/ru/codes/find_by_user/#{u.id}.html" , lastmod: u.updated_at, alternate: {href: "/en/codes/find_by_user/#{u.id}.html", lang: :en}
  end

end
