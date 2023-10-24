class RoomsController < ApplicationController
  before_action :set_room, only: %i[show edit update destroy]

  def index
    @rooms = Room.all
  end

  def show; end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)

    if @room.save
      respond_to do |format|
        format.html { redirect_to rooms_path, notice: 'room was successfully created.' }
        format.turbo_stream { flash.now[:notice] = 'room was successfully created.' }
      end
    else
      render :new, status: :unprocessable_entity
    end
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
    respond_to do |format|
      format.html { redirect_to rooms_path, notice: 'room was successfully destroyed.' }
      format.turbo_stream { flash.now[:notice] = 'room was successfully destroyed.' }
    end
  end

  private

  def room_params
    params.require(:room).permit(:id, :name)
  end

  def set_room
    @room = Room.find(params[:id])
  end
end
