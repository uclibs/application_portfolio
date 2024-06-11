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
    $page_title = 'Dashboard | UCL Application Portfolio'
    @user = "#{current_user.first_name} #{current_user.last_name}"
    @softwarerecords_indesign = SoftwareRecordsController.indesign_dashboard(@user).order("#{sort_column} #{sort_direction}")
    begin
      @indesign_count = @softwarerecords_indesign.count
    rescue StandardError
      @indesign_count = 0
    end
    @softwarerecords_production = SoftwareRecordsController.production_dashboard(@user).order("#{sort_column}
#{sort_direction}")
    begin
      @production_count = @softwarerecords_production.count
    rescue StandardError
      @production_count = 0
    end

    @softwarerecords_inchange = SoftwareRecordsController.inchange_dashboard(@user).order("#{sort_column} #{sort_direction}")
    # @software_change_hash = ChangeRequest.joins(:software_record).where('software_records.id = ?', @id)
    # @softwarerecords_change = SoftwareRecordsController.change_dashboard(@user).order("#{sort_column} #{sort_direction}").where(change_completed: true)
    begin
      @inchange_count = @softwarerecords_inchange.count
    rescue StandardError
      @inchange_count = 0
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
      redirect_to(root_path, alert: 'Cannot search on empty field!') && return
    else
      @parameter = params[:search].downcase
      search_term = "%#{@parameter}%"

      software_records_columns = SoftwareRecord.columns.map { |column| "lower(software_records.#{column.name}) LIKE :search" }
      @softwarerecords_results = SoftwareRecord.joins(:status)
                                               .where.not(statuses: { status_type: 'Decommissioned' })
                                               .where(software_records_columns.join(' OR '), search: search_term)

      vendor_records_columns = VendorRecord.columns.map { |column| "lower(#{column.name}) LIKE :search" }
      @vendorrecords_results = VendorRecord.where(vendor_records_columns.join(' OR '), search: search_term)

      software_types_columns = SoftwareType.columns.map { |column| "lower(#{column.name}) LIKE :search" }
      @softwaretypes_results = SoftwareType.where(software_types_columns.join(' OR '), search: search_term)
    end
  end

  def create
    @requestnewsoftwares = SoftwareRecord.new(params.require(:software_record).permit(:title,
                                                                                      :description, :status, :created_by,
                                                                                      :tentative_date_of_implementation, :notes, :departments, :product_owners, :software_type_id, :vendor_recor_id))
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
