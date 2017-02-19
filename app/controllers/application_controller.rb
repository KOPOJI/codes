class ApplicationController < ActionController::Base

  theme :light

  protect_from_forgery with: :exception

  require 'will_paginate/array'

 # include SimpleCaptcha::ControllerHelpers

  include ApplicationHelper

  before_action :set_language, :get_codes
  before_action :configure_permitted_parameters, if: :devise_controller?

  after_action :user_activity

  rescue_from ActiveRecord::RecordNotFound, with: :page_not_found

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to home_url, alert: (exception.message)
  end

  def page_not_found msg
    respond_to do |format|
      format.html { render '/errors/404', locals: {message: msg}, status: :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  def set_language
    I18n.locale =  params[:locale] || I18n.default_locale
    Rails.application.routes.default_url_options[:locale] = I18n.locale
  end

  def default_url_options(options = {})
    {locale: I18n.locale}
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
      @codes = Code.where('show_from="" AND status = 1').order(id: :desc)
    else
      unless current_user.admin?
        @codes = Code.where('show_from="" AND (status = 1 or user_id=?)', current_user.id).order(id: :desc)
      else
        @codes = Code.order(id: :desc)
      end
    end
    @codes = @codes.paginate(page: params[:page], per_page: 25)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :username
  end

  private

  def user_activity
    current_user.try :touch
  end

  require 'recaptcha.rb'
end
