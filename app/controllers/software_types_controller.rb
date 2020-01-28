# frozen_string_literal: true

# SoftwareTypes Controller
class SoftwareTypesController < ApplicationController
  layout 'software_records'
  before_action :authenticate_user!
  include SoftwareTypesHelper
  before_action :set_software_type, only: %i[show edit update destroy]
  # access all: %i[index show new edit create update destroy], user: :all
  access viewer: %i[index show], owner: %i[index show edit update], manager: %i[index show edit update new create destroy], root_admin: :all, message: 'Permission Denied ! <br/> Please contact the administrator for more info.'
  # GET /software_types
  def index
    $page_title = 'Software Types | Application Portfolio'
    @softwaretypes_count = SoftwareType.count
    @software_types = SoftwareType.order(sort_column + ' ' + sort_direction)
  end

  # GET /software_types/1
  def show
    $page_title = @software_type.title.to_s.upcase + ' | Application Portfolio'
  end

  # GET /software_types/new
  def new
    $page_title = 'New Software Type | Application Portfolio'
    @software_type = SoftwareType.new
  end

  # GET /software_types/1/edit
  def edit
    $page_title = 'Edit Software Type | Application Portfolio'
  end

  # POST /software_types
  def create
    @software_type = SoftwareType.new(software_type_params)

    if @software_type.save
      redirect_to @software_type, notice: 'Software type was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /software_types/1
  def update
    if @software_type.update(software_type_params)
      redirect_to @software_type, notice: 'Software type was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /software_types/1
  def destroy
    @software_type.destroy
    redirect_to software_types_url, notice: 'Software type was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_software_type
    @software_type = SoftwareType.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def software_type_params
    params.require(:software_type).permit(:title, :description)
  end
end
