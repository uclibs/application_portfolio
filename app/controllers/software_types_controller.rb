# frozen_string_literal: true

# SoftwareTypes Controller
class SoftwareTypesController < ApplicationController
  layout 'software_records'
  before_action :authenticate_user!
  include SoftwareTypesHelper
  before_action :set_software_type, only: %i[show edit update destroy]
  access all: %i[index show new edit create update destroy], user: :all
  $page_title = 'Application Portfolio | Software Types'
  # GET /software_types
  def index
    @softwaretypes_count = SoftwareType.count
    @software_types = SoftwareType.order(sort_column + ' ' + sort_direction)
  end

  # GET /software_types/1
  def show; end

  # GET /software_types/new
  def new
    @software_type = SoftwareType.new
  end

  # GET /software_types/1/edit
  def edit; end

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