module ApplicationHelper
  def display_errors(object)
    if object.errors.any?
      content_tag(:ul) do
        object.errors.full_messages.each do |message|
          concat content_tag(:li, message)
        end
      end
    end
  end
end
