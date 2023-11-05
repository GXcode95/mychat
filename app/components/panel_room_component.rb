# frozen_string_literal: true

class PanelRoomComponent < ViewComponent::Base
  def initialize(room, user:, **attributes)
    super
    @room = room
    @user = user
    @attributes = attributes
    @attributes[:id] = ids
  end

  def room_name
    @room.is_private? ? @room.display_name_for(@user) : @room.name
  end

  private

  def ids
    class_names("panel-room-#{@room.id}",
                @attributes[:id])
  end
end
