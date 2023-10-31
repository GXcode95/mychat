# frozen_string_literal: true

class MessageComponent < ViewComponent::Base
  def initialize(message, editable: false, **attributes)
    super
    @message = message
    @editable = editable
    @attributes = attributes
    @attributes[:class] = classes
    @attributes[:data] = datas
  end

  def author
    content_tag :p, @message.author.email, class: 'msg__author'
  end

  def content
    content_tag :p, @message.content, class: 'msg__content'
  end

  def edit_form
    data = {
      action: 'keydown->message-form#keydown submit->message-form#submit',
      'message-form-target': 'form'
    }
    semantic_form_for([@message.room, @message], data: data) do |f|
      f.input :content,
              value: @message.content,
              label: false,
              required: false,
              input_html: { class: 'bg-transparent w-full',
                            data: { 'message-form-target': 'input', controller: 'autoresize' } }
    end
  end

  def actions
    content_tag :div, class: 'msg__actions' do
      button_to_delete + link_to_edit
    end
  end

  private

  def classes
    class_names('msg',
                "msg--#{@message.author&.id}",
                @attributes[:class])
  end

  def datas
    @attributes[:data] ||= {}
    {
      **@attributes[:data],
      controller: 'scroll-to'
    }
  end

  def button_to_delete
    button_to 'delete', room_message_path(@message.room, @message), method: :delete
  end

  def link_to_edit
    link_to 'edit', edit_room_message_path(@message.room, @message)
  end
end
