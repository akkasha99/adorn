class Admin::AdminsController < ApplicationController
  before_action :authenticate_user!, :except => [:index]
  before_action :user_admin?, :except => [:dashboard]
  layout "admin"

  def index
    if user_signed_in?
      redirect_to '/admin/dashboard' if current_user.admin?
    else
      '/admin'
    end
  end

  def dashboard
  end

  private

  def user_admin?
    if user_signed_in?
      if current_user.admin?
        return true
      else
        return false
      end
    end
  end
end
