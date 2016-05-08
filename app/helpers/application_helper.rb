#require 'pascal'
module ApplicationHelper

  def app_name
    'SaveCode.RU'
  end

  def page_title title=nil
    return app_name if title.nil? or title.empty?
    "#{app_name} - #{title}"
  end

  def home_url
    "/#{locale}/"
  end

  def url_suffix
    '.html'
  end

  def create_url url=nil
    return home_url if url.nil?
    create_uri url
  end

  def create_url *url
    create_uri url.join('/')
  end

  def create_uri url
    url = home_url + url unless url.starts_with? home_url
    url += url_suffix unless url.end_with? url_suffix
    if url.include? 'codes'
      url += '?page=' + params[:page] unless params[:page].nil?
    end
    url
  end

  def current_code? url
    request.fullpath.include? "#{url}.html"
  end

  def show_chat?
    session[:show_chat].present?
  end

  def show_delete_links?
    user_signed_in? && current_user.admin? && session[:show_delete_link].present? && session[:show_delete_link]
  end

  def quote
    {
        'Quote' => [
            /\[quote(:.*)?=(?:&quot;|')?([-_.!? :a-zA-Z0-9А-ЯЁа-яё]*?[-_.!? :a-zA-Z0-9А-ЯЁа-яё][-_.!? :a-zA-Z0-9А-ЯЁа-яё]*?)(?:&quot;|')?\](.*?)\[\/quote\1?\]/miu,
            "<div class='bbcode_container'><div class='bbcode_quote'><div class='btbtbt'><div class='quote_container'><div class='bbcode_quote_container'></div><div class='bbcode_postedby'> <img title='Цитата' src=#{image_path 'quote_icon.png'} alt='Цитата'> Сообщение от <strong>\\2</strong></div> <div class='message'>\\3</div> </div> </div> </div> </div>",
            'Quote with citation',
            '[quote=mike]please quote me[/quote]',
            :quote
        ],
    }
  end

  def bootstrap_flash
    return nil if flash.nil? or flash.empty?
    classes = {'notice' => 'info', 'alert' => 'danger', 'success' => 'success', 'warning' => 'warning'}
    ret = ''
    flash.each do |key, value|
      key = classes.include?(key) ? classes[key]: key
      ret += content_tag(:div, value, class: "alert alert-#{key}")
    end
    ret
  end
end