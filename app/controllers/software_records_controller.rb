# frozen_string_literal: true

# SoftwareRecords Controller
class SoftwareRecordsController < ApplicationController
  layout 'software_records'
  include SoftwareRecordsHelper
  before_action :authenticate_user!
  before_action :set_software_record, only: %i[show edit update destroy]
  access all: %i[index show new edit create update destroy], user: :all
  # GET /software_records

  $page_title = 'Software Records | Application Portfolio'
  def index
    @softwarerecords_count = SoftwareRecord.count
    @software_records = SoftwareRecord.order(sort_column + ' ' + sort_direction)
  end

  def self.indesign_dashboard
    SoftwareRecord.where(status: 'In Design').or(SoftwareRecord.where(status: 'In Development'))
  end

  def self.production_dashboard
    SoftwareRecord.where(status: 'Production')
  end

  # GET /software_records/1
  def show; end

  # GET /software_records/new
  def new
    @software_record = SoftwareRecord.new
  end

  # GET /software_records/1/edit
  def edit; end

  # POST /software_records
  def create
    @software_record = SoftwareRecord.new(software_record_params)

    if @software_record.save
      redirect_to @software_record, notice: 'Software record was successfully created.'
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
      :it_quality
    )
  end
end
