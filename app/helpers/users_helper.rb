module UsersHelper
  def current_user? user
    user == current_user
  end
  def user_status_image user
    image_tag image_path("user_#{user.online? ? 'on' : 'off'}line.gif")
  end
end
