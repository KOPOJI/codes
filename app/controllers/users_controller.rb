class UsersController < ApplicationController
  before_action :authenticate_user!, only: :profile

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render xml: @user }
    end
  end

  def profile
    @user = current_user
    if request.patch? and @user.profile.update_attributes(profile_params)
      flash.now[:notice] = I18n.t 'Profile updated'
    end
    render action: :show

  end


  def show_hide_chat
    if session[:show_chat].present?
      session[:show_chat] = nil
    else
      session[:show_chat] = true
    end
    redirect_to :back and return
  end

  private
  def profile_params
    params.require(:profile).permit :name, :interests, :exp, :about_me, :signature, :avatar, :avatar_cache
  end

end
