# frozen_string_literal: true

class EditorComponent < ViewComponent::Base
  include Turbo::FramesHelper

  def initialize(message, **attributes)
    super
    @message = message
    @attributes = attributes
    @attributes[:class] = classes
    @attributes[:data] = datas
  end

  def form_attributes
    {
      data: {
        action: 'keydown->message-form#keydown submit->message-form#submit',
        'message-form-target': 'form'
      }
    }
  end

  def input_attributes
    {
      rows: 4,
      class: 'bg-neutral-300',
      data: { 'message-form-target': 'input' }
    }
  end

  private

  def classes
    class_names('bg-neutral-800',
                'py-2',
                'px-4',
                @attributes[:class])
  end

  def datas
    @attributes[:data] ||= {}
    {
      **@attributes[:data],
      controller: 'message-form'
    }
  end
end
