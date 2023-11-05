# frozen_string_literal: true

class PanelUserComponent < ViewComponent::Base
  def initialize(user, current_user:, **attributes)
    super
    @user = user
    @current_user = current_user
    @attributes = attributes
    @attributes[:class] = classes
    @attributes[:id] = ids
  end

  def user_action
    @current_user.private_room_with(@user) ? link_to_user_room : button_to_create_room
  end

  private

  def classes
    class_names(@user.online? ? 'text-primary' : 'text-neutral-400',
                @attributes[:class])
  end

  def ids
    class_names("panel_user_#{@user.id}",
                @attributes[:id])
  end

  def link_to_user_room
    link_to @user.email, room_path(@current_user.private_room_with(@user))
  end

  def button_to_create_room
    button_to @user.email,
              rooms_path,
              params: { room: { is_private: true, name: nil },
                        user_id: @user.id }
  end
end
