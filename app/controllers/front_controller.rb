# frozen_string_literal: true

class FrontController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]
  def index
    render 'index'
  end

  def dashboard
    render 'dashboard'
  end
end
