# frozen_string_literal: true

class FlashComponent < ViewComponent::Base
  def initialize(flash, flash_attributes: {}, **attributes)
    super
    @flash = flash
    @flash_attributes = flash_attributes
    @flash_attributes[:data] = flash_datas
    @attributes = attributes
    @attributes[:class] = classes
    @attributes[:id] = ids
  end

  def attributes_for(flash_type)
    {
      **@flash_attributes,
      class: class_names('flash__message', "flash--#{flash_type}", @flash_attributes[:class])
    }
  end

  private

  def ids
    class_names('flash', @attributes[:id])
  end

  def classes
    class_names('flash', @attributes[:class])
  end

  def flash_classes
    class_names('flash__message', @flash_attributes[:class])
  end

  def flash_datas
    @flash_attributes[:data] ||= {}
    {
      **@flash_attributes[:data],
      controller: 'removals',
      action: 'animationend->removals#remove click->removals#remove'
    }
  end
end
