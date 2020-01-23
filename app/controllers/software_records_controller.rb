# frozen_string_literal: true

# SoftwareRecords Controller
class SoftwareRecordsController < ApplicationController
  layout 'software_records'
  include SoftwareRecordsHelper
  before_action :authenticate_user!, except: %i[new create show]
  before_action :set_software_record, only: %i[show edit update destroy]
  access all: %i[create show], viewer: %i[index show], owner: %i[index show edit update], manager: %i[index show edit update new create destroy], root_admin: :all, message: 'Permission Denied ! <br/> Please contact the administrator for more info.'
  # GET /software_records

  def index
    $page_title = 'Software Records | Application Portfolio'
    @softwarerecords_count = SoftwareRecord.count
    @software_records = SoftwareRecord.order(sort_column + ' ' + sort_direction)
  end

  def self.indesign_dashboard(user)
    indesign_filter = SoftwareRecord.where(status: 'In Design')
    indev_filter = SoftwareRecord.where(status: 'In Development')
    user_filter = SoftwareRecord.where("created_by like '%#{user}%'")
    developer_filter = SoftwareRecord.where("developers like '%#{user}%'")
    tech_leads_filter = SoftwareRecord.where("tech_leads like '%#{user}%'")
    product_owners_filter = SoftwareRecord.where("product_owners like '%#{user}%'")
    currentuser_filter = user_filter.or(developer_filter).or(tech_leads_filter).or(product_owners_filter)
    dashboard_filter = indesign_filter.or(indev_filter)
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
    $page_title = 'New Software Record | Application Portfolio'
    @software_record = SoftwareRecord.new
  end

  # GET /software_records/1/edit
  def edit
    $page_title = 'Edit Software Record | Application Portfolio'
  end

  # POST /software_records
  def create
    @software_record = SoftwareRecord.new(software_record_params)

    if @software_record.save && user_signed_in?
      redirect_to @software_record, notice: 'Software record was successfully created.'
    elsif !user_signed_in? && @software_record.save
      redirect_to @software_record, notice: 'Software record was successfully requested.'
      RequestSoftwareMailerController.send_mail
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
    redirect_to software_records_url, notice: 'Software record was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_software_record
    @software_record = SoftwareRecord.find(params[:id])
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
      :departments,
      :developers,
      :tech_leads,
      :product_owners,
      :languages_used,
      :url,
      :user_seats,
      :annual_fees,
      :support_contract,
      :hosting_environment,
      :current_version,
      :notes,
      :business_value,
      :it_quality,
      :created_by,
      :tentative_date_implemented,
      :sensitive_information
    )
  end
end
