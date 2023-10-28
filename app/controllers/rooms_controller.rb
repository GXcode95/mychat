class RoomsController < ApplicationController
  before_action :set_room, only: %i[show edit update destroy]
  before_action :set_user, only: %i[create]

  def index
    @rooms = Room.public_rooms
  end

  def show
    @message = @room.messages.new
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.is_private
      build_users_room
    else
      build_owner
    end

    render :show and return if @room.save

    flash[:error] = @room.errors.full_messages.join("\n")
    render 'layouts/flash'
  end

  def edit; end

  def update
    if @room.update(room_params)
      redirect_to rooms_path, notice: 'room was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @room.destroy

    redirect_to rooms_path
  end

  private

  def room_params
    params.require(:room).permit(:id, :name, :is_private)
  end

  def set_room
    @room = Room.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def build_owner
    @room.users_rooms.build(user_id: current_user.id, role: :owner, status: :accepted)
  end

  def build_users_room
    @room.users_rooms.build([{ user: @user }, { user: current_user }])
  end
end
