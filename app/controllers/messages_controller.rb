class MessagesController < ApplicationController
  before_action :set_message, only: %i[edit update destroy]

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params.merge(author: current_user))
    return if @message.save

    flash[:error] = @message.errors.full_messages.join("\n")
    render 'layouts/flash'
  end

  def edit; end

  def update
    return if current_user != @message.author
    return if @message.update(message_params)

    flash[:error] = @message.errors.full_messages.join("\n")
    render 'layouts/flash'
  end

  def destroy
    return if current_user != @message.author

    @message.destroy
  end

  private

  def message_params
    params.require(:message).permit(:id, :content, :room_id)
  end

  def set_message
    @message = Message.find(params[:id])
  end
end
