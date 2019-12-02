# frozen_string_literal: true

module ApplicationHelper
  def alerts
    if flash[:alert]
      alert_generator flash[:alert], 'alert'
    elsif flash[:notice]
      alert_generator flash[:notice], 'notice'
    elsif flash[:error]
      alert_generator flash[:error], 'error'
    else
      alert_generator flash, 'warning'
    end
  end

  def alert_generator(msg, type)
    if type == 'alert'
      js add_gritter(msg, title: 'Application Portfolio', image: :notice, time: 3000, class_name: 'gritter')
    elsif type == 'notice'
      js add_gritter(msg, title: 'Application Portfolio', image: :progress, time: 3000, class_name: 'gritter')
    elsif type == 'error'
      js add_gritter(msg, title: 'Application Portfolio', image: :error, time: 3000, class_name: 'gritter')
    else
      js add_gritter(flash[:warning], title: 'Application Portfolio', image: :warning, time: 3000, class_name: 'gritter')
    end
  end
end
