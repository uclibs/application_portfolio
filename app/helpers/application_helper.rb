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
      js add_gritter(msg, title: 'UCL Application Portfolio', image: :notice, time: 3000, class_name: 'gritter')
    elsif type == 'notice'
      js add_gritter(msg, title: 'UCL Application Portfolio', image: :progress, time: 3000, class_name: 'gritter')
    elsif type == 'error'
      js add_gritter(msg, title: 'UCL Application Portfolio', image: :error, time: 3000, class_name: 'gritter')
    else
      js add_gritter(flash[:warning], title: 'UCL Application Portfolio', image: :warning, time: 3000, class_name: 'gritter')
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

  def generate_path(url)
    url = url.to_s
    url = if url.include?('http') || url.include?('https')
            url
          else
            'http://' + url
          end
    url
  end

  def clean_url(url)
    url = url.to_s
    url = if url.include?('https://')
            url.sub('https://', '')
          elsif url.include?('http://')
            url.sub('http://', '')
          else
            url
          end
    url
  end

  def navigation
    if session[:previous].nil?
      session[:previous] = request.original_url.to_s
      session[:current] = request.original_url.to_s
    elsif session[:current] != request.original_url.to_s
      prev = session[:current].to_s
      session[:previous] = prev
      session[:current] = request.original_url.to_s
    end
  end

  def generate_software_records_series
    series = [{ "data": {} }]
    current_year = Date.today.year
    current_month = Date.today.month
    months = Hash.new('month')
    months = { 1 => 'January' + ', ' + current_year.to_s,
               2 => 'February' + ', ' + current_year.to_s,
               3 => 'March' + ', ' + current_year.to_s,
               4 => 'April' + ', ' + current_year.to_s,
               5 => 'May' + ', ' + current_year.to_s,
               6 => 'June' + ', ' + current_year.to_s,
               7 => 'July' + ', ' + current_year.to_s,
               8 => 'August' + ', ' + current_year.to_s,
               9 => 'September' + ', ' + current_year.to_s,
               10 => 'October' + ', ' + current_year.to_s,
               11 => 'November' + ', ' + current_year.to_s,
               12 => 'December' + ', ' + current_year.to_s }
    month_keys = months.keys
    count = 0
    month_keys.each do |key|
      break if key > current_month

      start = DateTime.new(current_year, key, 0o1, 0o0, 0o0, 0o0)
      start_date = start.in_time_zone.beginning_of_month
      end_date = start.in_time_zone.end_of_month
      count += SoftwareRecord.where(created_at: start_date..end_date).count
      series[0][:data][months[key]] = count
    end
    series
  end
end
