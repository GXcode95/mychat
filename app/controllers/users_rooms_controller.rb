class UsersRoomsController < ApplicationController
  before_action :set_users_room, only: :destroy
  def create
    @users_room = UsersRoom.new(room_id: params[:room_id], user: current_user, role: :member, status: :accepted)
    return if @users_room.save

    flash[:error] = @users_room.errors.full_messages.join("\n")
    render 'layouts/flash'
  end

  def destroy
    @users_room.destroy
  end

  private

  def set_users_room
    @users_room = UsersRoom.find(params[:id])
  end
end
