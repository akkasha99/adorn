class Users::RegistrationsController < Devise::RegistrationsController

  before_action :check_platform, :only => [:new]

  def new
    if session[:webview] == '1'
      render "#{Rails.root}/app/views/devise/registrations/new", :layout => 'application'
    else
      render "#{Rails.root}/app/views/desktop/desktop/index", :layout => 'desktop'
    end
  end

  def create
    unless params[:user][:email].blank?
      role = Role.where(:title => "user").first
      user = User.new(user_params)
      user.skip_confirmation!
      user.save!
      user.role = role if role.present?
      NotificationSetting.create(:user_id => user.id)
      AdoornMailer.welcome_email(user).deliver
      uid = User.where(:email => "blogger@adoorn.com").first
      adoorner = UserAdoorner.create(:adoorner_id => user.id, :user_id => uid.id) if uid.present?
      #flash[:notice] = "You are successfully registered, Confirm your email to Sign in!"
      if user.present?
        render :partial => "/home/featured_brands", :locals => {:user_id => user.id, :@brands => Brand.all}
      else
        render :text => "error"
      end
    else
      render :text => "error"
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :user_name, :avatar, :about_me, :location, :password, :password_confirmation)
  end

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :user_name, :avatar, :about_me, :location, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :user_name, :avatar, :about_me, :location, :password, :password_confirmation, :current_password)
  end
end
