# frozen_string_literal: true

class FrontController < ApplicationController
  layout 'application'
  include ApplicationHelper
  include SoftwareRecordsHelper
  before_action :authenticate_user!, only: %i[dashboard profile search]
  before_action :navigation
  helper_method :sort_column, :sort_direction

  def index
    $page_title = 'Welcome | UCL Application Portfolio'
    @controller = params[:controller]
  end

  def dashboard
    @vendor_piechart_hash = {}
    VendorRecord.all.each do |vendor|
      @vendor_piechart_hash[vendor.title] = VendorRecord.find_by_id(vendor.id).software_records.count
    end
    @test = [{ 'ORDER_CODE' => 519_805, 'PART' => '00049', 'LEAD_TIME' => 29, 'DATE' => '2015-03-03T00:00:00' }, { 'ORDER_CODE' => 517_297, 'PART' => '00149', 'LEAD_TIME' => 54, 'DATE' => '2014-11-26T00:00:00' }]
    @data = @test.collect { |i| [i['ORDER_CODE'], i['lead_time']] }
    $page_title = 'Dashboard | UCL Application Portfolio'
    @user = current_user.first_name + ' ' + current_user.last_name
    @softwarerecords_indesign = SoftwareRecordsController.indesign_dashboard(@user).order(sort_column + ' ' + sort_direction)
    begin
      @indesign_count = @softwarerecords_indesign.count
    rescue StandardError
      @indesign_count = 0
    end
    @softwarerecords_production = SoftwareRecordsController.production_dashboard(@user).order(sort_column + ' ' + sort_direction)
    begin
      @production_count = @softwarerecords_production.count
    rescue StandardError
      @production_count = 0
    end
    render 'dashboard'
  end

  def about
    $page_title = 'About Us | UCL Application Portfolio'
    render 'about'
  end

  def contact
    $page_title = 'Contact Us | UCL Application Portfolio'
    render 'contact'
  end

  def profile
    $page_title = 'My Profile | UCL Application Portfolio'
    @users = User.all
    render 'profile'
  end

  def new
    $page_title = 'Request Software | UCL Application Portfolio'
    @requestnewsoftwares = SoftwareRecord.new
  end

  def search
    if params[:search].blank?
      redirect_to(root_path, alert: 'Cannot search on empty field !') && return
    else
      @parameter = params[:search].downcase
      @totalcolumns_softwarerecords = SoftwareRecord.columns.count
      @softwarerecords_column_count = 0
      @softwarerecords_query = ''
      SoftwareRecord.columns.each do |column|
        @softwarerecords_column_count += 1
        @softwarerecords_query += if @totalcolumns_softwarerecords != @softwarerecords_column_count
                                    "(lower(#{column.name}) LIKE :search) or"
                                  else
                                    "(lower(#{column.name}) LIKE :search)"
                                  end
      end

      @totalcolumns_vendorrecords = VendorRecord.columns.count
      @vendorrecords_column_count = 0
      @vendorrecords_query = ''
      VendorRecord.columns.each do |column|
        @vendorrecords_column_count += 1
        @vendorrecords_query += if @totalcolumns_vendorrecords != @vendorrecords_column_count
                                  "(lower(#{column.name}) LIKE :search) or"
                                else
                                  "(lower(#{column.name}) LIKE :search)"
                                end
      end

      @totalcolumns_softwaretypes = SoftwareType.columns.count
      @softwaretypes_column_count = 0
      @softwaretypes_query = ''
      SoftwareType.columns.each do |column|
        @softwaretypes_column_count += 1
        @softwaretypes_query += if @totalcolumns_softwaretypes != @softwaretypes_column_count
                                  "(lower(#{column.name}) LIKE :search) or"
                                else
                                  "(lower(#{column.name}) LIKE :search)"
                                end
      end
      @softwarerecords_results = SoftwareRecord.all.where(@softwarerecords_query, search: "%#{@parameter}%")
      @softwaretypes_results = SoftwareType.all.where(@softwaretypes_query, search: "%#{@parameter}%")
      @vendorrecords_results = VendorRecord.all.where(@vendorrecords_query, search: "%#{@parameter}%")
    end
  end

  def create
    @requestnewsoftwares = SoftwareRecord.new(params.require(:software_record).permit(:title, :description, :status, :created_by, :tentative_date_of_implementation, :notes, :departments, :product_owners, :software_type_id, :vendor_recor_id))
    if @requestnewsoftwares.save
      AdminMailer.send_email(params[:id], params[:created_by])
      redirect_to @request_softwares, notice: 'Software record was successfully requested.'
    else
      redirect_to request_new_path
    end
  end

  private

  def sort_column
    SoftwareRecord.column_names.include?(params[:sort]) ? params[:sort] : 'title'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
