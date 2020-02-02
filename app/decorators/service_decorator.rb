# frozen_string_literal: true

module ServiceDecorator
  def formatted_remind_on
    if Date.current.year == remind_on.year
      I18n.l remind_on, format: :short
    else
      I18n.l remind_on
    end
  end

  def formatted_renewed_on
    if Date.current.year == renewed_on.year
      I18n.l renewed_on, format: :short
    else
      I18n.l renewed_on
    end
  end
end
