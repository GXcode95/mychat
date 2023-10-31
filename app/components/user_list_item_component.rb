# frozen_string_literal: true

class UserListItemComponent < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(users_room, **attributes)
    super
    @users_room = users_room
  end

  def username
    content_tag :span, @users_room.user.email
  end

  def actions
    if @users_room.accepted?
      button_to_delete
    else
      button_to_accept + button_to_reject
    end
  end

  def frame_id
    @users_room.accepted? ? dom_id(@users_room, 'member') : dom_id(@users_room, 'request')
  end

  private

  def button_to_delete
    button_to :Delete,
              users_room_path(@users_room),
              method: :delete,
              class: 'btn btn-danger btn-outline'
  end

  def button_to_accept
    button_to :Accept,
              users_room_path(@users_room),
              method: :put,
              params: { users_room: { status: :accepted } },
              class: 'btn btn-success btn-outline'
  end

  def button_to_reject
    button_to :Reject,
              users_room_path(@users_room),
              method: :delete,
              class: 'btn btn-danger btn-outline'
  end
end
