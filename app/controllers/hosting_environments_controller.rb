# frozen_string_literal: true

# HostingEnvironments Controller
class HostingEnvironmentsController < ApplicationController
  layout 'software_records'
  helper_method :sort_column, :sort_direction
  include ApplicationHelper
  include SoftwareRecordsHelper
  before_action :authenticate_user!, except: %i[new create show]
  before_action :set_hosting_environment, only: %i[show edit update destroy]
  before_action :navigation, except: %i[edit update]
  access root_admin: :all

  # GET /hosting_environments
  def index
    $page_title = 'Hosting Environments | UCL Application Portfolio'
    @hosting_environments = HostingEnvironment.all
    @hosting_env_counts = HostingEnvironment.all.count
  end

  # GET /hosting_environments/1
  def show
    $page_title = "#{@hosting_environment.title.to_s.upcase} | UCL Application Portfolio"
  end

  # GET /hosting_environments/new
  def new
    $page_title = 'New Hosting Environment | UCL Application Portfolio'
    @hosting_environment = HostingEnvironment.new
  end

  # GET /hosting_environments/1/edit
  def edit
    $page_title = 'Edit Hosting Environment | UCL Application Portfolio'
  end

  # POST /hosting_environments
  def create
    @hosting_environment = HostingEnvironment.new(hosting_environment_params)

    if @hosting_environment.save
      redirect_to @hosting_environment, notice: 'Hosting environment was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /hosting_environments/1
  def update
    if @hosting_environment.update(hosting_environment_params)
      redirect_to @hosting_environment, notice: 'Hosting environment was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /hosting_environments/1
  def destroy
    @hosting_environment.destroy
    redirect_to hosting_environments_url, notice: 'Hosting environment was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_hosting_environment
    @hosting_environment = HostingEnvironment.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def hosting_environment_params
    params.require(:hosting_environment).permit(:title, :description)
  end
end
