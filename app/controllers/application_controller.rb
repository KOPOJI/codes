class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  require 'will_paginate/array'

  before_action :set_language, :get_codes
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  after_action :user_activity

  rescue_from ActiveRecord::RecordNotFound, with: :page_not_found

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to '/', alert: (exception.message)
  end

  def page_not_found msg
    respond_to do |format|
      format.html { render '/errors/404', locals: {message: msg}, status: :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  def set_language
    if session[:language].blank? or session[:language].to_sym != I18n.locale
      session[:language] = 'ru' if session[:language].blank?
      session[:language] = (['ru', 'en'].include? session[:language]) ? session[:language] : 'ru'
      I18n.locale =  session[:language].to_sym
    end
  end

  def show_delete_link
   if session[:show_delete_link].nil?
     session[:show_delete_link] = false
   else
     session[:show_delete_link] = !session[:show_delete_link]
   end
  end

  def get_codes
    #@codes = Code.order(id: :desc).where(status: true).paginate(page: params[:page],per_page: 15)
    unless user_signed_in?
      @codes = Code.where('(show_from IS NULL OR show_from="") AND status = 1').order(id: :desc)
    else
      unless current_user.admin?
        @codes = Code.where('(show_from IS NULL OR show_from="") AND (status = 1 or user_id=?)', current_user.id).order(id: :desc)
      else
        @codes = Code.order(id: :desc)
      end
    end
    @codes = @codes.paginate(page: params[:page], per_page: 15)
  end
  
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :username
  end
  
  private

  def user_activity
    current_user.try :touch
  end
end
