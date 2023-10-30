class MessagesController < ApplicationController
  load_and_authorize_resource

  # def new; end

  def edit; end

  def create
    @message = Message.new(message_params.merge(author: current_user))
    return if @message.save

    flash.now[:error] = @message.errors.full_messages.join("\n")
    render 'layouts/flash', status: :unprocessable_entity
  end

  def update
    return if @message.update(message_params)

    flash.now[:error] = @message.errors.full_messages.join("\n")
    render 'layouts/flash', status: :unprocessable_entity
  end

  def destroy
    @message.destroy
  end

  private

  def message_params
    params.require(:message).permit(:id, :content, :room_id)
  end
end
