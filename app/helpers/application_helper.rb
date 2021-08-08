module ApplicationHelper 

  def tool_tip(text, tooltip_text, tip_options={}, text_options={})
    text = text.to_s.html_safe
    if (tooltip_text.present?)
      content_tag :span, title: '' do
        concat content_tag(:span, text, add_classes_to_options(text_options, "tooltip_parent"))
        concat content_tag(:span, tooltip_text, add_classes_to_options(tip_options, "tooltip").merge({style: "display:none"}))
      end
    else
      return text
    end
  end


  def add_classes_to_options(html_options, classes_to_add)
    if html_options[:class].present?
      class_string = html_options[:class]
      class_string = class_string.split(" ").concat(classes_to_add.split(" ")).uniq.join(" ")
    else
      class_string = classes_to_add
    end
    return html_options.reject{|attribute, value| attribute.to_sym == :class}.merge(class: class_string)
  end
end
