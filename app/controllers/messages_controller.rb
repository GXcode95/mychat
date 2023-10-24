class MessagesController < ApplicationController
  before_action :set_message, only: %i[show edit update destroy]

  def index
    @messages = Message.all
  end

  def show; end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.author = current_user

    if @message.save
      respond_to do |format|
        format.html { redirect_to messages_path, notice: 'message was successfully created.' }
        format.turbo_stream { flash.now[:notice] = 'message was successfully created.' }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @message.update(message_params)
      redirect_to messages_path, notice: 'message was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_path, notice: 'message was successfully destroyed.' }
      format.turbo_stream { flash.now[:notice] = 'message was successfully destroyed.' }
    end
  end

  private

  def message_params
    params.require(:message).permit(:id, :content)
  end

  def set_message
    @message = Message.find(params[:id])
  end
end
