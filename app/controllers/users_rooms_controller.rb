class UsersRoomsController < ApplicationController
  before_action :set_users_room, only: %i[update destroy]
  before_action :set_room, only: :create

  def create
    @users_room = @room.users_rooms.new(user: current_user,
                                        role: :member,
                                        status: :pending)
    return if @users_room.save

    flash[:error] = @users_room.errors.full_messages.join("\n")
    render 'layouts/flash'
  end

  def update
    @users_room.update(users_room_params)
  end

  def destroy
    @users_room.destroy
  end

  private

  def set_users_room
    @users_room = UsersRoom.find(params[:id])
  end

  def users_room_params
    params.require(:users_room).permit(:status, :role)
  end

  def set_room
    @room = Room.find(params[:room_id])
  end
end
