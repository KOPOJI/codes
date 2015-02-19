class PrivateMessagesController < ApplicationController
  before_action :set_private_message, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /private_messages
  # GET /private_messages.json
  def index
    render action: :inbox
  end

  def inbox
    @messages = PrivateMessage.where(user_to_id: current_user.id, deleted_by_to_user: false).order(id: :desc).paginate(per_page: 12, page: params[:pm_page])
    render :messages
  end

  def outbox
    @messages = PrivateMessage.where(user_from_id: current_user.id, deleted_by_from_user: false).order(id: :desc).paginate(per_page: 12, page: params[:pm_page])
    render :messages
  end

  # GET /private_messages/1
  # GET /private_messages/1.json
  def show
    if params[:type].present?
      if params[:type] == 'inbox'
        @message = PrivateMessage.where(id: params[:id], deleted_by_to_user: false).limit(1)[0]
      else
        @message = PrivateMessage.where(id: params[:id], deleted_by_from_user: false).limit(1)[0]
      end
      @message = nil if params[:type].nil?
      if @message.present?
        if params[:type] == 'inbox'
          can_read = @message.user_to_id == current_user.id
        else
          can_read = @message.user_from_id == current_user.id
        end
        @message = nil unless can_read
      end
      @message.present? and params[:type] == 'inbox' and @message.update(read: true)
    end
  end

  # GET /private_messages/new
  def new
    @private_message = PrivateMessage.new
  end

  # GET /private_messages/1/edit
  def edit
  end

  # POST /private_messages
  # POST /private_messages.json
  def create
    @private_message = PrivateMessage.new(private_message_params)

    respond_to do |format|
      @private_message.user_from_id = current_user.id
      if @private_message.save
        unless User.where(id: @private_message.user_to_id).count.zero?
          ActionMailer::Base.mail(
              from: 'SaveCode.RU <admin@savecode.ru>',
              to: "#{@private_message.user_to.username} <#{@private_message.user_to.email}>",
              subject: 'SaveCode.RU сообщает о новом личном сообщении',
              body: render_to_string(file: 'private_messages/email', layout: false)
          ).deliver if @private_message.user_to_id && @private_message.user_to_id != @private_message.user_from_id

          format.html { redirect_to "/pm/outbox/#{@private_message.id}.html", notice: I18n.t('Private message was successfully created') }
          format.json { render action: 'show', status: :created, location: @private_message }
        else
          @private_message.errors.add(:user_to_id, t('This user not found'))
          format.html { render action: 'new' }
          format.json { render json: @private_message.errors, status: :unprocessable_entity }
        end
      else
        format.html { render action: 'new' }
        format.json { render json: @private_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /private_messages/1
  # PATCH/PUT /private_messages/1.json
  def update
    respond_to do |format|
      @private_message.user_from_id = current_user.id
      if @private_message.update(private_message_params)
        format.html { redirect_to "/pm/#{request.fullpath.include?('outbox')?'out':'in'}box/#{@private_message.id}.html", notice: I18n.t('Private message was successfully updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @private_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /private_messages/1
  # DELETE /private_messages/1.json
  def destroy
    if current_user.id == @private_message.user_from_id
      @private_message.update(deleted_by_from_user: true)
    else
      @private_message.update(deleted_by_to_user: true)
    end
    @private_message.destroy if @private_message.deleted_by_to_user and @private_message.deleted_by_from_user or (@private_message.user_from_id == @private_message.user_to_id && @private_message.user_from_id = current_user.id)

    respond_to do |format|
      format.html { redirect_to "/pm/#{request.referrer.include?('outbox') ? 'out' : 'in'}box.html" }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_private_message
    @private_message = PrivateMessage.where(id: params[:id], deleted_by_to_user: false)[0]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def private_message_params
    params.require(:private_message).permit(:title, :text, :file, :user_to_id, :to_message_id)
  end
end
