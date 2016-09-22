class Admin::UsersController < Admin::AdminsController

  def index
    active_users = User.all.map { |u| u if (u.isactive == true && u.hide_as_user == false && u.user?) }.reverse
    inactive_users = User.all.map { |u| u if (u.isactive == false && u.hide_as_user == false && u.user?) }.reverse
    render :partial => 'all_users', :locals => {:@active_users => active_users.compact!, :@inactive_users => inactive_users.compact!}
  end

  def new
    render :partial => 'new_user', :locals => {:@user => User.new}
  end

  def create
    user1 = User.where(:user_name => params[:user][:user_name]).first
    if params[:user][:email].blank?
      user2 = nil
    else
      user2 = User.where(:email => params[:user][:email]).first
    end
    if user1.blank? && user2.blank?
      @user = User.new(user_params)
      @user.skip_confirmation!
      if @user.save!
        role = Role.where(:title => "user").first
        @user.role = role
        NotificationSetting.create(:user_id => @user.id)
        uid = User.where(:email => "blogger@adoorn.com").first
        adoorner = UserAdoorner.create(:adoorner_id => user.id, :user_id => uid.id) if uid.present?
        index
      else
        new
      end
    else
      render :text => 'present'
    end
  end

  def edit
    @user = User.find(params[:id]) if params[:id].present?
    render :partial => 'edit_user', :locals => {:@user => (@user if @user.present?)}
  end

  def update
    user1 = User.where(:user_name => params[:user][:user_name]).where.not(:id => params[:user_id]).first
    user2 = User.where(:email => params[:user][:email]).where.not(:id => params[:user_id]).first
    if user1.blank? && user2.blank?
      user = User.find(params[:user_id]) if params[:user_id].present?
      user.skip_reconfirmation!
      user.update_attributes(:avatar => params[:user][:avatar], :first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :location => params[:user][:location], :about_me => params[:user][:about_me], :email => params[:user][:email], :user_name => params[:user][:user_name], :hide_as_user => params[:user][:hide_as_user]) if user.present?
      if user.user_feed.present?
        user_feed = user.user_feed
        pre_feed = user_feed.url
        if params[:user][:user_feed_attributes][:url] != pre_feed
          user_feed.update_attributes(:url => params[:user][:user_feed_attributes][:url], :is_active => 2)
        end
      end
      index
    else
      render :text => "present"
    end
  end

  def delete
    user = User.find(params[:id]) if params[:id].present?
    user.destroy if user.present?
    index
  end

  def activate_deactivate_user
    user = User.find(params[:id]) if params[:id].present?
    if (user.isactive==true)
      user.update_attributes(:isactive => false)
    else
      user.update_attributes(:isactive => true)
    end
    index
  end

  def reported_users
    reported_users = Report.where("reports.is_viewed= false && reports.user_id IS NOT NULL").order("created_at DESC")
    render :partial => 'reported_users', :locals => {:reported_users => reported_users}
  end

  def reported_items
    reported_items = Report.where("reports.is_viewed= false && reports.user_item_id IS NOT NULL")
    render :partial => 'reported_items', :locals => {:reported_items => reported_items}
  end

  def reported_outfits
    reported_outfits = Report.where("reports.is_viewed= false && reports.user_outfit_id IS NOT NULL")
    render :partial => 'reported_outfits', :locals => {:reported_outfits => reported_outfits}
  end

  def reported_blogs
    reported_blogs = Report.where("reports.is_viewed= false && reports.user_blog_id IS NOT NULL")
    render :partial => 'reported_blogs', :locals => {:reported_blogs => reported_blogs}
  end

  def report_update
    report = Report.find(params[:id])
    report.update_attributes(:is_viewed => true)
    if (params[:goto] == 'users')
      reported_users
    elsif (params[:goto] == 'items')
      reported_items
    elsif (params[:goto] == 'outfits')
      reported_outfits
    else
      reported_blogs
    end
  end

  def user_name_present
    user1 = User.find(params[:id])
    @user = User.where(:user_name => params[:user][:user_name]).first
    render :text => "true" and return if @user.blank?
    if @user.user_name == user1.user_name
      render :text => "true" if @user.present?
    else
      render :text => "false" if @user.present?
    end
  end

  def user_email_present
    user1 = User.find(params[:id])
    @user = User.where(:email => params[:user][:email]).first
    render :text => "true" and return if @user.blank?
    if @user.email == user1.email
      render :text => "true" if @user.present?
    else
      render :text => "false" if @user.present?
    end
  end

  private
  def user_params
    #params.require(:user).permit(:first_name, :last_name, :user_name, :email, :password, :password_confirmation, :about_me, :location, :avatar)
    #add blog url at user creation in admin as sub-form
    params.require(:user).permit(:first_name, :last_name, :user_name, :email, :password, :password_confirmation, :about_me, :location, :avatar, :hide_as_user, :user_feed_attributes => [:url, :user_id, :id, :is_active])
  end

  def report_params
    params.require(:user).permit(:by_user, :user_id, :comment, :user_item_id, :user_outfit_id, :user_blog_id)
  end

end
