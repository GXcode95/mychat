class RoomsController < ApplicationController
  load_and_authorize_resource

  before_action :set_user, only: %i[create]

  def index
    @rooms = Room.public_rooms
  end

  def show; end

  def new; end

  def edit; end

  def create
    @room = Room.new(room_params)
    build_users_rooms
    redirect_to @room and return if @room.save

    flash.now[:error] = @room.errors.full_messages.join("\n")
    render 'layouts/flash', status: :unprocessable_entity
  end

  def update
    redirect_to @room and return if @room.update(room_params)

    flash.now[:error] = @room.errors.full_messages.join("\n")
    render 'layouts/flash', status: :unprocessable_entity
  end

  def destroy
    @room.destroy

    redirect_to rooms_path
  end

  private

  def room_params
    params.require(:room).permit(:id, :name, :is_private)
  end

  def set_user
    @user = User.find_by(id: params[:user_id])
  end

  def build_users_rooms
    if @room.is_private?
      @room.users_rooms.build([{ user: @user }, { user: current_user }])
    else
      @room.users_rooms.build(user_id: current_user.id, role: :owner, status: :accepted)
    end
  end
end
