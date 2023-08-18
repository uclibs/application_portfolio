# frozen_string_literal: true

# Status Controller
class StatusesController < ApplicationController
  layout 'software_records'
  helper_method :sort_column, :sort_direction
  include ApplicationHelper
  include SoftwareRecordsHelper
  before_action :authenticate_user!, except: %i[new create show]
  before_action :set_status, only: %i[show edit update destroy]
  before_action :navigation, except: %i[edit update]

  access all: %i[create show], viewer: %i[index show], owner: %i[index show edit update new create destroy],
         manager: %i[index show edit update new create destroy], root_admin: :all, message: 'Permission Denied ! <br/> Please contact the administrator for more info.'

  # GET /statuses
  def index
    $page_title = 'Status | UCL Application Portfolio'
    @statuses = Status.all
    @statuses_count = Status.all.count
  end

  # GET /statuses/1
  def show
    $page_title = "#{@status.title.to_s.upcase} | UCL Application Portfolio"
  end

  # GET /statuses/new
  def new
    $page_title = 'New Status | UCL Application Portfolio'
    @status = Status.new
  end

  # GET /statuses/1/edit
  def edit
    $page_title = 'Edit Status | UCL Application Portfolio'
  end

  # POST /statuses
  def create
    @status = Status.new(status_params)

    if @status.save
      redirect_to @status, notice: 'Status was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /statuses/1
  def update
    if @status.update(status_params)
      redirect_to @status, notice: 'Status was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /statuses/1
  def destroy
    @status.destroy
    redirect_to statuses_url, notice: 'Status was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_status
    @status = Status.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def status_params
    params.require(:status).permit(:title, :status_type)
  end
end
