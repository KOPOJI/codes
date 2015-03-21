module CodesHelper

  def parse_bb_codes text

    return if text.nil? or text.empty?

    text = escape_backslash(CGI.escapeHTML text)
    text.gsub! /\[b\](.*?)\[\/b\]/i, '<span class="bold">\\1</span>'
    text.gsub! /\[i\](.*?)\[\/i\]/i, '<span class="cursive">\\1</span>'
    text.gsub! /\[u\](.*?)\[\/u\]/i, '<span class="underline">\\1</span>'
    text.gsub! /\[s\](.*?)\[\/s\]/i, '<span class="del">\\1</span>'
    text.gsub!(/\[img\](https?:\/\/[^<>]+?)\[\/img\]/i, '<a href="\\1" rel="prettyPhoto[]"><img src="\\1" class="attach"></a>')

    text.scan(/\[url=&quot;(.+?)&quot;\](.*?)\[\/url\]/ium).each do |url|
      if url[0] =~ /^#{URI::regexp(%w(http https))}$/
        text.sub! /\[url=&quot;(.+?)&quot;\](.*?)\[\/url\]/ium, link_to('\\2', '\\1', class: 'link', target: '_blank')
      end
    end

    code_list = codes
    code_regexp = code_list.values.join('|').gsub(/\s+/u, '')

    text.scan(/\[(#{code_regexp})\](.*?)\[\/\1\]/ium).each do |match|
	  lexer = match[0].downcase == 'c_cpp' ? 'cpp' : match[0].downcase
      lexer = Rouge::Lexer.find(lexer) ? lexer : 'text'
      title = match[0]
      code_list.each{ |k, v| title = k if /\A(?:#{v})\z/ui =~ match[0] }
      text.sub! /\[#{Regexp.escape match[0]}\]#{Regexp.escape match[1]}\[\/#{Regexp.escape match[0]}\]/i,
                "#{lang_title title}#{Rouge.highlight(CGI.unescapeHTML(match[1]), lexer, 'html')}"
    end

    text.gsub '<br>', ''
  end

  def codes
    code = File.readlines("#{Rails.root}/app/languages.txt")
    code_list = {}
    code.each{|line| tmp = line.strip.split(' => '); code_list[tmp.last] = tmp.first }
    code_list
  end
  def visible? code
    referer = request.env['HTTP_REFERER']
    code.present? && (user_signed_in? && !current_user.admin? && current_user.id != code.user_id) || !(referer.nil? || (referer.present? && !referer.include?(code.show_from)))
  end

  def nl2br text
    text.gsub /\n(?!\s*?&lt;div\s*?class=&quot;lang)/, '<br>'
  end

  def escape_backslash str
    str.gsub '\\', '\\\\\\'
  end

  def can_edit? code, editable=false
    return false if code.nil?
    return true if !user_signed_in? && !code.user_id
    return true if user_signed_in? && current_user.admin? or code.user_id.nil? && !editable && code.editable
    return false if !user_signed_in? and !code.user_id.nil?
    return (code.user_id == current_user.id)

    code.user_id == current_user.id or code.editable or current_user.admin?
  end

  private
  def lang_title lang
    "<h6>#{t('Code')} #{lang}</h6><div class='code' lang='#{lang.downcase}'></div>"
  end

  def render_options
    { filter_html: true, hard_wrap: true, line_numbers: true, start_line: 1 }
  end
  def engine_options
    { fenced_code_blocks: true, autolink: true }
  end

end
