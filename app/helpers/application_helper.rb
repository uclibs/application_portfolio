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

  def nav_helper(style)
    if current_user
      (link_to 'Dashboard', dashboard_path, class: "#{style} #{active? dashboard_path}") + ' '.html_safe +
        (link_to 'About', about_path, class: "#{style} #{active? about_path}") + ' '.html_safe +
        (link_to 'Contact', contact_path, class: "#{style} #{active? contact_path}")
    else
      (link_to 'Request Software', request_new_path, class: "#{style} #{active? request_new_path}") + ' '.html_safe +
        (link_to 'Login', new_user_session_path, class: "#{style} #{active? new_user_session_path}") + ' '.html_safe +
        (link_to 'About', about_path, class: "#{style} #{active? about_path}") + ' '.html_safe +
        (link_to 'Contact', contact_path, class: "#{style} #{active? contact_path}")
    end
  end

  def active?(path)
    'active' if current_page? path
  end
end
