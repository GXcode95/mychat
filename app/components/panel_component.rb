# frozen_string_literal: true

class PanelComponent < ViewComponent::Base
  include CanCan::Ability

  renders_many :sections

  def initialize(user:, variant:, room: nil, **attributes)
    super
    @current_user = user
    @variant = variant
    @room = room
    @attributes = attributes
    @attributes[:class] = classes
    @attributes[:data] = datas
  end

  def can?(*args)
    current_ability.can?(*args)
  end

  def cannot?(*args)
    current_ability.cannot?(*args)
  end

  def current_ability
    @current_ability ||= ::Ability.new(@current_user)
  end

  def classes
    class_names('panel',
                "panel-#{@variant}",
                @attributes[:class])
  end

  def datas
    @attributes[:data] ||= {}
    {
      **@attributes[:data],
      controller: 'hide'
    }
  end

  def panel_actions
    content_tag :div, class: 'panel__actions' do
      if @variant == :left
        rooms_link + hide_action
      elsif @variant == :right
        hide_action + settings_link
      end
    end
  end

  def user_menu
    content_tag :div, class: 'panel__user-menu' do
      edit_link + logout_link
    end
  end

  def public_rooms
    @current_user.joined_public_rooms
  end

  def private_rooms
    @current_user.private_rooms
  end

  def room_users
    @room.accepted_users.all_except(@current_user)
  end

  private

  def private_room_link(user)
    if @current_user.private_room_with(user)
      link_to user.email, room_path(@current_user.private_room_with(user))
    else
      button_to user.email, rooms_path, params: { room: { is_private: true, name: nil },
                                                  user_id: user.id }
    end
  end

  def room_link(room)
    link_to "- #{room.display_name_for(@current_user)}", room_path(room), data: { turbo_frame: 'main'}
  end

  def edit_link
    link_to 'Settings', edit_user_registration_path, data: { turbo_frame: 'main' }
  end

  def rooms_link
    link_to 'R', rooms_path, data: { turbo_frame: 'main' }
  end

  def settings_link
    return unless can?(:update, @room)

    link_to 'S', edit_room_path(@room), class: 'text-white', data: { turbo_frame: 'main' }
  end

  def logout_link
    button_to 'Logout', destroy_user_session_path, method: :delete
  end

  def hide_action
    content_tag :div, 'X',
                class: 'toggle',
                data: { action: 'click->hide#hide' }
  end


end
