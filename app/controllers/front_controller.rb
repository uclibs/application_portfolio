# frozen_string_literal: true

class FrontController < ApplicationController
  layout 'application'
  before_action :authenticate_user!, only: %i[dashboard profile]

  def index
    $page_title = 'Welcome | Application Portfolio'
    @controller = params[:controller]
  end
  
  def dashboard
    @vendor_piechart_hash = {}
    VendorRecord.all.each do |vendor|
      @vendor_piechart_hash[vendor.title] = VendorRecord.find_by_id(vendor.id).software_records.count
    end
    $page_title = 'Dashboard | Application Portfolio'
    @user = current_user.first_name + ' ' + current_user.last_name
    @softwarerecords_indesign = SoftwareRecordsController.indesign_dashboard(@user)
    begin
      @indesign_count = @softwarerecords_indesign.count
    rescue StandardError
      @indesign_count = 0
    end
    @softwarerecords_production = SoftwareRecordsController.production_dashboard(@user)
    begin
      @production_count = @softwarerecords_production.count
    rescue StandardError
      @production_count = 0
    end
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

  def profile
    $page_title = 'My Profile | Application Portfolio'
    @users = User.all
    render 'profile'
  end

  def new
    $page_title = 'Request Software | Application Portfolio'
    @requestsoftwaress = SoftwareRecord.new
  end

  def create
    @requestsoftwaress = SoftwareRecord.new(params.require(:software_record).permit(:title, :description, :status, :created_by, :tentative_date_of_implementation, :notes, :departments, :product_owners, :software_type_id, :vendor_recor_id))
    if @requestsoftwaress.save
      AdminMailer.send_email(params[:id], params[:created_by])
      redirect_to @request_softwares, notice: 'Software record was successfully requested.'
    else
      redirect_to request_new_path
    end
  end
end
