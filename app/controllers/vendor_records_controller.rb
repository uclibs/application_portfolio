# frozen_string_literal: true

# VendorRecords Controller
class VendorRecordsController < ApplicationController
  layout 'software_records'
  include VendorRecordsHelper
  before_action :authenticate_user!
  before_action :set_vendor_record, only: %i[show edit update destroy]
  # access all: %i[index show new edit create update destroy], user: :all
  access viewer: %i[index show], owner: %i[index show edit update], manager: %i[index show edit update new create destroy], root_admin: :all, message: 'Permission Denied ! <br/> Please contact the administrator for more info.'
  # GET /vendor_records
  def index
    $page_title = 'Vendor Records | UCL Application Portfolio'
    @vendorrecords_count = VendorRecord.count
    @vendor_records = VendorRecord.order(sort_column + ' ' + sort_direction)
  end

  # GET /vendor_records/1
  def show
    $page_title = @vendor_record.title.to_s.upcase + ' | UCL Application Portfolio'
  end

  # GET /vendor_records/new
  def new
    $page_title = 'New Vendor Record | UCL Application Portfolio'
    @vendor_record = VendorRecord.new
  end

  # GET /vendor_records/1/edit
  def edit
    $page_title = 'Edit Vendor Record | UCL Application Portfolio'
  end

  # POST /vendor_records
  def create
    @vendor_record = VendorRecord.new(vendor_record_params)

    if @vendor_record.save
      redirect_to @vendor_record, notice: 'Vendor record was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /vendor_records/1
  def update
    if @vendor_record.update(vendor_record_params)
      redirect_to @vendor_record, notice: 'Vendor record was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /vendor_records/1
  def destroy
    @vendor_record.destroy
    redirect_to vendor_records_url, notice: 'Vendor record was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_vendor_record
    @vendor_record = VendorRecord.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def vendor_record_params
    params.require(:vendor_record).permit(:title, :description)
  end
end
