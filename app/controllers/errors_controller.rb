class ErrorsController < ApplicationController

  def show
    status_code = params[:code] || 500
    flash.alert = I18n.t(status_code.to_s)
    render status_code.to_s, status: status_code
  end

end
