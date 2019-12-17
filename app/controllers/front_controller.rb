# frozen_string_literal: true

class FrontController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]
  def index
    $page_title = 'Welcome | Application Portfolio'
    @controller = params[:controller]
    render 'index'
  end

  def dashboard
    $page_title = 'Dashboard | Application Portfolio'
    @softwarerecords_indesign = SoftwareRecordsController.indesign_dashboard
    @indesign_count = @softwarerecords_indesign.count
    @softwarerecords_production = SoftwareRecordsController.production_dashboard
    @production_count = @softwarerecords_production.count
    render 'dashboard'
  end

  def about
    $page_title = 'About Us | Application Portfolio'
    render 'about'
  end

  def contact
    $page_title = 'Contact Us | Application Portfolio'
    render 'contact'
  end
end
