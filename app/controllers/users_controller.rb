# frozen_string_literal: true

# UsersController
class UsersController < ApplicationController
  include ApplicationHelper
  include SoftwareRecordsHelper
  before_action :retrieve_user, only: %i[show edit update destroy user_status]
  before_action :authenticate_user!
  before_action :navigation, except: %i[edit update]
  access root_admin: :all,
         message: 'Permission Denied ! <br/> Please contact the administrator for more info.'
  helper_method :sort_column, :sort_direction

  def index
    @users = User.order("#{sort_column} #{sort_direction}")
    @active = 'users'
    $page_title = 'Manage Users | UCL Application Portfolio'
  end

  def edit
    $page_title = 'Edit Users | UCL Application Portfolio'
    render :edit
  end

  def update
    $page_title = 'Edit Users | UCL Application Portfolio'
    @user.first_name = params[:first_name]
    @user.last_name = params[:last_name]
    @user.title = params[:title]
    @user.department = params[:department]
    @user.email = params[:email]
    @user.roles = params[:roles]
    @user.active = params[:active]
    if !@user.changed? && @user.save
      redirect_to user_edit_path(params[:id]), alert: 'Please modify any field to update the User.'
    elsif @user.changed? && @user.save
      redirect_to users_show_path(params[:id]), notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def show
    $page_title = "#{@user.first_name} #{@user.last_name} | UCL Application Portfolio"
    render :show
  end

  def retrieve_user
    @user = User.find(params[:id])
    @controller = params[:controller]
  end

  def user_status
    if @user.active.to_s == 'true'
      @user.active = false
      @user.save
      redirect_to users_show_path(params[:id]), notice: 'User was successfully de-activated.'
    else
      @user.active = true
      @user.save
      redirect_to users_show_path(params[:id]), notice: 'User was successfully activated.'
    end
  end

  def destroy
    if @user.destroy
      redirect_to session[:previous], notice: 'User was successfully deleted.'
    else
      render :index
    end
  end

  private

  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : 'first_name'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end
end
