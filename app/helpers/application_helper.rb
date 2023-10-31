module ApplicationHelper
  def render_turbo_stream_flash_messages
    turbo_stream_action_tag(:replace,
                            target: 'flash',
                            template: render(FlashComponent.new(flash), content_type: 'text/html'))
  end
end
