# frozen_string_literal: true

class PanelSectionComponent < ViewComponent::Base
  renders_many :items

  def initialize(title:, list_attributes: {}, **attributes)
    super
    @title = title
    @list_attributes = list_attributes
    @attributes = attributes
  end

  def header
    content_tag :h3, @title
  end
end
