# frozen_string_literal: true

# SoftwareTypes helper
module SoftwareTypesHelper
  def sort_column
    SoftwareType.column_names.include?(params[:sort]) ? params[:sort] : 'title'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
