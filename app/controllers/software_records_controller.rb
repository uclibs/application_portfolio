# frozen_string_literal: true

# SoftwareRecords Controller
class SoftwareRecordsController < ApplicationController
  layout 'software_records'
  helper_method :sort_column, :sort_direction
  include ApplicationHelper
  include SoftwareRecordsHelper
  before_action :authenticate_user!, except: %i[new create show]
  before_action :set_software_record, only: %i[show edit update destroy]
  before_action :navigation, except: %i[edit update]
  access all: %i[create show], viewer: %i[index show], owner: %i[index show edit update list_upgrades],
         manager: %i[index show edit update new create destroy list_upgrades], root_admin: :all, message: 'Permission Denied ! <br/> Please contact the administrator for more info.'
  # GET /software_records

  def index
    $page_title = 'Software Records | UCL Application Portfolio'
    @params = request.query_parameters

    @software_records = if @params['filter_by'].to_s == 'software_types' && !@params['software_type_filter'].nil? && !@params['software_type_filter'].empty?
                          SoftwareRecord.where(software_type_id: @params['software_type_filter']).order("#{sort_column} #{sort_direction}")
                        elsif @params['filter_by'].to_s == 'vendor_records' && !@params['vendor_record_filter'].nil? && !@params['vendor_record_filter'].empty?
                          SoftwareRecord.where(vendor_record_id: @params['vendor_record_filter']).order("#{sort_column} #{sort_direction}")
                        else
                          SoftwareRecord.order("#{sort_column} #{sort_direction}")
                        end
    @vendor_records = VendorRecord.all
    @software_types = SoftwareType.all
    @softwarerecords_count = SoftwareRecord.count
  end

  def self.indesign_dashboard(user)
    design_status = Status.where(status_type: 'Design')
    design_filter = SoftwareRecord.where(status_id: 0)
    design_status.each do |design|
      design_filter = design_filter.or(SoftwareRecord.where(status_id: design.id))
    end
    developer_filter = SoftwareRecord.where("developers like '%#{user}%'")
    tech_leads_filter = SoftwareRecord.where("tech_leads like '%#{user}%'")
    product_owners_filter = SoftwareRecord.where("product_owners like '%#{user}%'")
    currentuser_filter = developer_filter.or(tech_leads_filter).or(product_owners_filter)
    design_filter.merge(currentuser_filter)
  end

  def self.production_dashboard(user)
    production_status = Status.where(status_type: 'Production')
    production_filter = SoftwareRecord.where(status_id: 0)
    production_status.each do |production|
      production_filter = production_filter.or(SoftwareRecord.where(status_id: production.id))
    end
    developer_filter = SoftwareRecord.where("developers like '%#{user}%'")
    tech_leads_filter = SoftwareRecord.where("tech_leads like '%#{user}%'")
    product_owners_filter = SoftwareRecord.where("product_owners like '%#{user}%'")
    currentuser_filter = developer_filter.or(tech_leads_filter).or(product_owners_filter)
    production_filter.merge(currentuser_filter)
  end

  def self.inchange_dashboard(user)
    inchange_filter = SoftwareRecord.joins(:change_request).where(change_request: { change_completed: false })

    inchange_complete = SoftwareRecord.joins(:change_request).where(change_request: { change_completed: false })
    inchange_filter = SoftwareRecord.joins(:change_request).where(change_request: { change_completed: false })
    inchange_complete.each do |_change|
      inchange_filter = inchange_filter.or(SoftwareRecord.where(change_request: { change_completed: false }))
    end

    developer_filter = SoftwareRecord.where('developers like ?', "%#{user}%")
    tech_leads_filter = SoftwareRecord.where('tech_leads like ?', "%#{user}%")
    product_owners_filter = SoftwareRecord.where('product_owners like ?', "%#{user}%")
    currentuser_filter = developer_filter.or(tech_leads_filter).or(product_owners_filter)

    inchange_filter.merge(currentuser_filter)
  end

  # GET /software_records/1
  def show
    $page_title = "#{@software_record.title.to_s.upcase} | Application Portfolio"
    @decrypted_sensitive_information = check_and_decrypt(SoftwareRecord.find_by(id: params[:id]).sensitive_information)
  end

  # GET /software_records/new
  def new
    $page_title = 'New Software Record | UCL Application Portfolio'
    @software_record = SoftwareRecord.new
    @decrypted_sensitive_information = ''
  end

  # GET /software_records/1/edit
  def edit
    $page_title = 'Edit Software Record | UCL Application Portfolio'

    @decrypted_sensitive_information = check_and_decrypt(SoftwareRecord.find_by(id: params[:id]).sensitive_information)
    @count_developers = 2
    @count_tech_leads = 2
    @count_product_owners = 2
    @count_departments = 2
  end

  # POST /software_records
  def create
    @software_record = SoftwareRecord.new(software_record_params)
    @software_record.sensitive_information = check_and_encrypt(@software_record.sensitive_information)
    if @software_record.save && user_signed_in?
      redirect_to @software_record, notice: 'Software record was successfully created.'
    elsif !user_signed_in? && @software_record.save
      if verify_recaptcha(model: @software_record)
        AdminMailer.new_software_request_mail(@software_record.id,
                                              @software_record.created_by).deliver_now
        redirect_to @software_record, notice: 'Software record was successfully requested.'
      else
        flash[:error] = 'reCaptcha not verified. Please try again and verify reCaptcha.'
        redirect_to request_new_path
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
    software_update_params = software_record_params
    software_update_params[:sensitive_information] =
      check_and_encrypt(software_update_params[:sensitive_information])
    software_update_params[:departments] = software_record_params[:departments]
    software_update_params[:developers] = software_record_params[:developers]
    software_update_params[:tech_leads] = software_record_params[:tech_leads]
    software_update_params[:product_owners] = software_record_params[:product_owners]
    software_update_params[:admin_users] = software_record_params[:admin_users]
    if @software_record.update(software_update_params)
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

  def check_and_encrypt(sensitive_data)
    # Encrypt 'Sensitive Information' field before saving into db if it's not empty.
    encrypt sensitive_data if sensitive_data.to_s.present?
  end

  def check_and_decrypt(sensitive_data)
    # Encrypt 'Sensitive Information' field before saving into db if it's not empty.
    decrypt sensitive_data if sensitive_data.to_s.present?
  end

  def list_upgrades
    $page_title = 'Maintenance Priority| UCL Application Portfolio'
    @params = request.query_parameters

    @software_records = if @params['filter_by'].to_s == 'software_types' && !@params['software_type_filter'].nil? && !@params['software_type_filter'].empty?
                          SoftwareRecord.where(software_type_id: @params['software_type_filter']).order("#{sort_priority} #{sort_direction_priority}")
                        elsif @params['filter_by'].to_s == 'vendor_records' && !@params['vendor_record_filter'].nil? && !@params['vendor_record_filter'].empty?
                          SoftwareRecord.where(vendor_record_id: @params['vendor_record_filter']).order("#{sort_priority} #{sort_direction_priority}")
                        else
                          SoftwareRecord.order("#{sort_priority} #{sort_direction_priority}")
                        end
    @vendor_records = VendorRecord.all
    @software_types = SoftwareType.all
    @softwarerecords_count = SoftwareRecord.count
  end
  
  def list_road_map
    $page_title = 'Road Map | UCL Application Portfolio'
    @params = request.query_parameters
     
    @software_records = if @params['filter_by'].to_s == 'software_types' && !@params['software_type_filter'].nil? && !@params['software_type_filter'].empty?
                          SoftwareRecord.where(software_type_id: @params['software_type_filter']).order("#{sort_priority} #{sort_direction_priority}")
                        elsif @params['filter_by'].to_s == 'vendor_records' && !@params['vendor_record_filter'].nil? && 
!@params['vendor_record_filter'].empty?
                          SoftwareRecord.where(vendor_record_id: @params['vendor_record_filter']).order("#{sort_priority} #{sort_direction_priority}")
                        else
                          SoftwareRecord.order("#{sort_priority} #{sort_direction_priority}")
                        end
    @vendor_records = VendorRecord.all 
    @software_types = SoftwareType.all
    @softwarerecords_count = SoftwareRecord.count
  end

  def edit_road_map
    @software_record = SoftwareRecord.find(params[:id])
  end

  def update_road_map
    @software_record = SoftwareRecord.find(params[:id])
    if @software_record.update(road_map_params)
      redirect_to list_road_map_path, notice: 'Road map was successfully updated.'
    else
      render :edit_road_map
    end
  end

  private

  def road_map_params
    params.require(:software_record).permit(:road_map)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_software_record
    @software_record = SoftwareRecord.find(params[:id])
  end

  def sort_priority
    SoftwareRecord.column_names.include?(params[:sort]) ? params[:sort] : 'priority'
  end

  def sort_direction_priority
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
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
      :themes,
      :modules,
      :title,
      :description,
      :status_id,
      :software_type_id,
      :vendor_record_id,
      :authentication_type,
      :date_implemented,
      :date_of_upgrade,
      :languages_used,
      :production_url,
      :source_code_url,
      :user_seats,
      :annual_fees,
      :support_contract,
      :hosting_environment_id,
      :current_version,
      :notes,
      :business_value,
      :it_quality,
      :created_by,
      :requires_cm,
      :last_security_scan,
      :last_accessibility_scan,
      :last_ogc_review,
      :last_info_sec_review,
      :cm_stakeholders,
      :cm_other_notes,
      :sensitive_information,
      :qa_url,
      :dev_url,
      :prod_url,
      :production_support_servers,
      :last_record_change,
      :track_uptime,
      :monitor_health,
      :monitor_errors,
      :service,
      :installed_version,
      :latest_version,
      :proposed_version,
      :road_map,
      :last_upgrade_date,
      :upgrade_available,
      :vulnerabilities_reported,
      :vulnerabilities_fixed,
      :bug_fixes,
      :new_features,
      :breaking_changes,
      :end_of_life,
      :priority,
      :upgrade_status,
      :who,
      :semester,
      :upgrade_docs,
      :qa_support_servers,
      :dev_support_servers,
      :date_cert_expires,
      :monitor_certificates,
      tech_leads: [],
      developers: [],
      product_owners: [],
      admin_users: [],
      departments: []
    )
  end
end
