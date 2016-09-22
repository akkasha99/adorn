class Desktop::UsersController < ApplicationController
  layout 'desktop'
  @@locations = ['United States', 'United Kingdom', 'France', 'Deutschland', 'Japan', 'Australia', 'Canada']

  def profile
    @user = current_user if current_user.present?
  end

  def profile_update
    if params.present?
      user1 = User.where(:user_name => params[:user][:user_name]).where.not(:id => params[:user_id]).first
      user2 = User.where(:email => params[:user][:email]).where.not(:id => params[:user_id]).first
      if user1.blank? && user2.blank?
        user = User.find(params[:user_id]) if params[:user_id].present?
        if params[:profile]== nil
          if params[:user][:user_feed_attributes][:url] != user.user_feed.url && params[:user][:user_feed_attributes][:url] != ''
            user.user_feed.is_active = 2
          end
        end
        user.update_attributes!(users_params)
        if user.valid_password?(params[:Old_Password])
          user.update_attributes(:password => params[:user][:password]) if user.present?
          sign_in user, :bypass => true
        end
      else
        flash[:error] = "Email or user name already taken."
      end
    end
    redirect_to '/user/profile'
  end

  def privacy_policy

  end

  private

  def users_params
    params.require(:user).permit(:user_name, :email, :first_name, :last_name, :location, :about_me, :avatar, :user_feed_attributes => [:url, :user_id, :id])
  end
end
