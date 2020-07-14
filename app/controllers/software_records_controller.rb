# frozen_string_literal: true

# SoftwareRecords Controller
class SoftwareRecordsController < ApplicationController
  layout 'software_records'
  helper_method :sort_column, :sort_direction
  include ApplicationHelper
  include SoftwareRecordsHelper
  before_action :authenticate_user!, except: %i[new create show]
  before_action :set_software_record, only: %i[show edit update destroy]
  before_action :navigation
  access all: %i[create show], viewer: %i[index show], owner: %i[index show edit update], manager: %i[index show edit update new create destroy], root_admin: :all, message: 'Permission Denied ! <br/> Please contact the administrator for more info.'
  # GET /software_records

  def index
    $page_title = 'Software Records | UCL Application Portfolio'
    @params = request.query_parameters

    @software_records = if @params['filter_by'].to_s == 'software_types' && !@params['software_type_filter'].nil? && !@params['software_type_filter'].empty?
                          SoftwareRecord.where("software_type_id ='#{@params['software_type_filter']}'").order(sort_column + ' ' + sort_direction)
                        elsif @params['filter_by'].to_s == 'vendor_records' && !@params['vendor_record_filter'].nil? && !@params['vendor_record_filter'].empty?
                          SoftwareRecord.where("vendor_record_id ='#{@params['vendor_record_filter']}'").order(sort_column + ' ' + sort_direction)
                        else
                          SoftwareRecord.order(sort_column + ' ' + sort_direction)
                        end
    @vendor_records = VendorRecord.all
    @software_types = SoftwareType.all
    @softwarerecords_count = SoftwareRecord.count
  end

  def self.indesign_dashboard(user)
    indesign_filter = SoftwareRecord.where(status: 'In Design')
    indev_filter = SoftwareRecord.where(status: 'In Development')
    inup_filter = SoftwareRecord.where(status: 'In Upgrade')
    user_filter = SoftwareRecord.where("created_by like '%#{user}%'")
    developer_filter = SoftwareRecord.where("developers like '%#{user}%'")
    tech_leads_filter = SoftwareRecord.where("tech_leads like '%#{user}%'")
    product_owners_filter = SoftwareRecord.where("product_owners like '%#{user}%'")
    currentuser_filter = user_filter.or(developer_filter).or(tech_leads_filter).or(product_owners_filter)
    dashboard_filter = indesign_filter.or(indev_filter).or(inup_filter)
    dashboard_filter.merge(currentuser_filter)
  end

  def self.production_dashboard(user)
    production_filter = SoftwareRecord.where(status: 'Production')
    user_filter = SoftwareRecord.where(created_by: user)
    developer_filter = SoftwareRecord.where("developers like '%#{user}%'")
    tech_leads_filter = SoftwareRecord.where("tech_leads like '%#{user}%'")
    product_owners_filter = SoftwareRecord.where("product_owners like '%#{user}%'")
    currentuser_filter = user_filter.or(developer_filter).or(tech_leads_filter).or(product_owners_filter)
    production_filter.merge(currentuser_filter)
  end

  # GET /software_records/1
  def show
    $page_title = @software_record.title.to_s.upcase + ' | Application Portfolio'
  end

  # GET /software_records/new
  def new
    $page_title = 'New Software Record | UCL Application Portfolio'
    @software_record = SoftwareRecord.new
  end

  # GET /software_records/1/edit
  def edit
    $page_title = 'Edit Software Record | UCL Application Portfolio'
    @count_developers = 2
    @count_tech_leads = 2
    @count_product_owners = 2
    @count_departments = 2
  end

  # POST /software_records
  def create
    @software_record = SoftwareRecord.new(software_record_params)
    if @software_record.save && user_signed_in?
      redirect_to @software_record, notice: 'Software record was successfully created.'
    elsif !user_signed_in? && @software_record.save
      if !verify_recaptcha(model: @software_record)
        flash[:error] = 'reCaptcha not verified. Please try again and verify reCaptcha.'
        redirect_to request_new_path
      else
        AdminMailer.new_software_request_mail(@software_record.id, @software_record.created_by).deliver_now
        redirect_to @software_record, notice: 'Software record was successfully requested.'
      end
    elsif !user_signed_in? && !@software_record.save
      flash[:error] = 'All mandatory fields are required.'
      redirect_to request_new_path
    elsif user_signed_in? && (current_user.role.to_s == 'owner' || current_user.role.to_s == 'viewer')
      flash[:error] = 'All mandatory fields are required.'
      redirect_to request_new_path
    else
      render :new
    end
  end

  # PATCH/PUT /software_records/1
  def update
    if @software_record.update(software_record_params)
      redirect_to @software_record, notice: 'Software record was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /software_records/1
  def destroy
    @software_record.destroy
    redirect_to session[:previous], notice: 'Software record was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_software_record
    @software_record = SoftwareRecord.find(params[:id])
  end

  def sort_column
    SoftwareRecord.column_names.include?(params[:sort]) ? params[:sort] : 'title'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  # Only allow a trusted parameter "white list" through.
  def software_record_params
    params.require(:software_record).permit(
      :title,
      :description,
      :status,
      :software_type_id,
      :vendor_record_id,
      :date_implemented,
      :date_of_upgrade,
      :languages_used,
      :production_url,
      :source_code_url,
      :user_seats,
      :annual_fees,
      :support_contract,
      :hosting_environment,
      :current_version,
      :notes,
      :business_value,
      :it_quality,
      :created_by,
      :sensitive_information,
      tech_leads: [],
      developers: [],
      product_owners: [],
      departments: []
    )
  end
end
