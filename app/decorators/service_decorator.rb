# frozen_string_literal: true

module ServiceDecorator
  def formatted_notified_on
    if Date.current.year == notified_on.year
      I18n.l notified_on, format: :short
    else
      I18n.l notified_on
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
