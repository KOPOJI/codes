class CodesController < ApplicationController
  before_action :set_code, only: [:show, :edit, :update, :destroy]
  before_action {extend CodesHelper}

  def index
    #@code = Code.order(id: :desc).find_by(status: 1, show_from: nil)
    #render action: :show
  end

  def show
    if (user_signed_in? && !current_user.admin?) && @code && @code.show_from && !can_edit?(@code)
      @code = nil unless visible? @code
    end
    if @code.nil?
      redirect_to root_path, alert: I18n.t('code_not_found') and return
    else
      @attachments = @code.attachments
    end

    @highlighter = Rouge::Formatters::HTML.new render_options

  end

  def new
    @code = Code.new
    @attachments = @code.attachments.build
  end

  def edit
    raise CanCan::AccessDenied unless can_edit? @code
  end

  def create
    @code = Code.new(code_params)

    @code.user_id = current_user.id if user_signed_in?

    respond_to do |format|
      if @code.save
        if params[:attachments].present?
          params[:attachments]['image'].each do |a|
            @attachments = @code.attachments.create!(image: a, code_id: @code.id)
          end
        end
        format.html { redirect_to @code, notice: I18n.t('Code was successfully created') }
        format.json { render action: 'show', status: :created, location: @code }
      else
        format.html { render action: 'new' }
        format.json { render json: @code.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if can_edit? @code
      respond_to do |format|
        #add admin user_id to code
        @code.user_id = current_user.id if !params[:add_admin_id].nil? and user_signed_in? and current_user.admin?

        if @code.update(code_params)
          if params[:attachments].present?
            params[:attachments]['image'].each do |a|
              @attachments = @code.attachments.create!(image: a, code_id: @code.id)
            end
          end
          format.html { redirect_to "/codes/#{@code.code_url.empty? ? @code.id : @code.code_url}.html", notice: I18n.t('Code was successfully updated') }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @code.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    @code.destroy
    respond_to do |format|
      format.html { redirect_to codes_url }
      format.json { head :no_content }
    end
  end

  def language
    session[:language] = params[:language][0..1]
    set_language
    redirect_to root_path
  end

  private
  def set_code
    if params[:id] =~ /^\d+$/
      unless user_signed_in?
        @code = Code.find_by_id_and_status(params[:id], 1)
      else
        unless current_user.admin?
          @code = Code.where('id=? AND (status = 1 or user_id=?)', params[:id], current_user.id)
        else
          @code = Code.find(params[:id])
        end
      end
    else
      unless user_signed_in?
        @code = Code.find_by_code_url_and_status(params[:id], 1)
      else
        unless current_user.admin?
          @code = Code.where('code_url=? AND (status = 1 or user_id=?)', params[:id], current_user.id)
        else
          @code = Code.find_by_code_url(params[:id])
        end
      end
    end

    return if @code.nil?

    if user_signed_in?
      unless current_user.admin?
        @code = @code.first unless current_user.admin? && @code.count.zero?
      end
    else
      @code = @code.first unless @code
    end
  end

  def code_params
    if user_signed_in?
      params.require(:code).permit(:code, :title, :editable, :status, :show_from, attachments_attributes: [:id, :code_id, :image])
    else
      params.require(:code).permit(:code, :title, attachments_attributes: [:id, :code_id, :image])
    end
  end

end