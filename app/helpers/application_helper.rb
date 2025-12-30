# frozen_string_literal: true

module ApplicationHelper
  def notice_class(type)
    case type
    when 'notice'
      'success'
    when 'alert'
      'danger'
    else
      'primary'
    end
  end
end
