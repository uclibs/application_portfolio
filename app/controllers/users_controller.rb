# frozen_string_literal: true

# UsersController
class UsersController < ApplicationController
  before_action :retrieve_user, only: %i[show edit update destroy user_status]
  before_action :authenticate_user!
  access admin: :all, message: 'Permission Denied ! <br/> Please contact the administrator for more info.'

  def index
    @users = User.all
    @active = 'users'
    $page_title = 'Manage Users | Application Portfolio'
  end

  def edit
    $page_title = 'Edit Users | Application Portfolio'
    render :edit
  end

  def update
    $page_title = 'Edit Users | Application Portfolio'
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
    $page_title = @user.first_name.to_s + ' ' + @user.last_name.to_s + ' | Application Portfolio'
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
      redirect_to users_path, notice: 'User was successfully deleted.'
    else
      render :index
    end
  end
end
