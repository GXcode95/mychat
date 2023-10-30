class UsersRoomsController < ApplicationController
  load_and_authorize_resource except: :create

  before_action :set_room, only: :create

  def create
    @users_room = @room.users_rooms.new(user: current_user,
                                        role: :member,
                                        status: :pending)
    authorize! :create, @users_room
    @users_room.save

    # return if @users_room.save
    # flash.now[:error] = @users_room.errors.full_messages.join("\n")
    # render 'layouts/flash'
  end

  def update
    return if @users_room.update(users_room_params)

    flash.now[:error] = @users_room.errors.full_messages.join("\n")
    render 'layouts/flash', status: :unprocessable_entity
  end

  def destroy
    @users_room.destroy
  end

  private

  def users_room_params
    params.require(:users_room).permit(:status, :role)
  end

  def set_room
    @room = Room.find(params[:room_id])
  end
end
