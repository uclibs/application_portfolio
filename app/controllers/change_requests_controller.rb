# frozen_string_literal: true

class ChangeRequestsController < ApplicationController
  layout 'software_records'
  helper_method :sort_column, :sort_direction
  include ApplicationHelper
  include SoftwareRecordsHelper
  before_action :authenticate_user!, except: %i[new create show]
  before_action :set_change_request, only: %i[show edit update destroy]
  before_action :navigation, except: %i[edit update]
  access root_admin: :all

  def index
    $page_title = 'Change Requests | UCL Application Portfolio'
    @change_requests = ChangeRequest.all
    @change_request_counts = ChangeRequest.all.count
  end

  def show
    $page_title = "#{@change_request.change_title.to_s.upcase} | UCL Application Portfolio"
    @software_name = SoftwareRecord.where(id: @change_request.software_record_id).first.title
  end

  def new
    $page_title = 'New Change Requests | UCL Application Portfolio'
    @change_request = ChangeRequest.new
  end

  # GET /hosting_environments/1/edit
  def edit
    $page_title = 'Edit Change Request | UCL Application Portfolio'
  end

  # POST /hosting_environments
  def create
    @change_request = ChangeRequest.new(change_request_params)
    if @change_request.save
      redirect_to @change_request, notice: 'Change request was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /hosting_environments/1
  def update
    if @change_request.update(change_request_params)
      redirect_to @change_request, notice: 'Change Request was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /hosting_environments/1
  def destroy
    @change_request.destroy
    redirect_to change_requests_url, notice: 'Change request was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_change_request
    @change_request = ChangeRequest.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def change_request_params
    params.require(:change_request).permit(:change_title, :software_record_id, :change_description, :change_submitted_date, :change_completed)
  end
end
