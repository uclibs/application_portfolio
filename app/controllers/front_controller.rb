# frozen_string_literal: true

class FrontController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]
  def index
    session[:login] = 1
    $page_title = 'Application Portfolio | Welcome'
    render 'index'
  end

  def dashboard
    session[:login] = session[:login].to_i + 1
    $page_title = 'Application Portfolio | Dashboard'
    if session[:login].to_i == 2
      redirect_to welcome_path
    else
      render 'dashboard'
    end
  end

  def welcome
    $page_title = 'Application Portfolio | Welcome'
    render 'welcome'
  end

  def about
    $page_title = 'Application Portfolio | About Us'
    render 'about'
  end

  def contact
    $page_title = 'Application Portfolio | Contact Us'
    render 'contact'
  end
end
