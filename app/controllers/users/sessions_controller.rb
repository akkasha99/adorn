class Users::SessionsController < Devise::SessionsController
  layout "application"

  before_action :check_platform, :only => [:new]

  def new
    if params[:mobile] == 'true'
      session[:webview] = '1'
      render "#{Rails.root}/app/views/devise/sessions/new", :layout => 'application'
    elsif session[:webview] == '1'
      render "#{Rails.root}/app/views/devise/sessions/new", :layout => 'application'
    else
      render "#{Rails.root}/app/views/desktop/desktop/index", :layout => 'desktop'
    end
  end

  def create
    user = User.where(:user_name => params[:user][:user_name]).first
    if user.present?
      if user.isactive == false
        flash[:error] = "User is not active to login."
        redirect_to '/users/sign_out'
      else
        super
      end
    else
      flash[:error] = "The username or password you entered is incorrect."
      redirect_to '/users/sign_in'
    end
  end

  def destroy_mobile
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_flashing_format?
    yield if block_given?
    redirect_to '/users/sign_in?mobile=true'
  end

end
