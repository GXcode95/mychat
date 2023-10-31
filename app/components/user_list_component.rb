# frozen_string_literal: true

class UserListComponent < ViewComponent::Base
  def initialize(users_rooms:, title:, list_attributes: {}, **attributes)
    super
    @users_rooms = users_rooms
    @attributes = attributes
    @title = title
    @list_attributes = list_attributes
  end

  def title
    title_class = class_names('text-center', 'text-2xl', 'font-bold', 'leading-9',
                              'tracking-tight', 'text-gray-900')

    content_tag :h2, @title, class: title_class
  end
end
