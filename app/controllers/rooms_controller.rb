class RoomsController < ApplicationController
  before_action :set_room, only: %i[show edit update destroy]

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
    build_owner
    return if @room.save

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
    params.require(:room).permit(:id, :name)
  end

  def set_room
    @room = Room.find(params[:id])
  end

  def build_owner
    @room.users_rooms.build(user_id: current_user.id, role: :owner, status: :accepted)
  end
end
