# frozen_string_literal: true

class RoomComponent < ViewComponent::Base
  def initialize(room, user:, **attributes)
    super
    @room = room
    @user = user
    @users_room = @room.users_rooms.find_by(user_id: @user.id)
    @attributes = attributes
    @attributes[:class] = classes
  end

  def room_name
    if @users_room&.accepted?
      link_to @room.name, room_path(@room), data: { turbo_frame: '_top' }, class: 'text-primary font-bold'
    else
      content_tag :span, @room.name, class: 'room__title'
    end
  end

  def action
    if @users_room.nil?
      button_to_join
    elsif @users_room.accepted?
      button_to_leave
    elsif @users_room.pending?
      button_request_send
    end
  end

  private

  def classes
    class_names('flex',
                'justify-between',
                'items-center',
                'px-2')
  end

  def button_to_join
    button_to :Join,
              users_rooms_path,
              class: 'btn btn-success btn-outline',
              params: { room_id: @room.id }
  end

  def button_to_leave
    button_to :Leave,
              users_room_path(@users_room),
              method: :delete,
              class: 'btn btn-danger btn-outline'
  end

  def button_request_send
    button_to 'Request send',
              users_rooms_path,
              disabled: true,
              class: 'btn btn-success btn-outline disabled',
              params: { room_id: @room.id }
  end
end
