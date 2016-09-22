class User::UsersController < ApplicationController
  include ActionView::Helpers::DateHelper
  before_action :user_user?, :except => [:check_email, :check_username, :edit_pass, :android_image_up]
  before_action :check_platform, :only => [:news_feed]
  layout 'application'
  @@locations = ['United States', 'Canada']
  #@@locations = ['United States', 'United Kingdom', 'France', 'Deutschland', 'Japan', 'Australia', 'Canada']
  @@socials = ['facebook', 'twitter', 'instagram', 'tumblr']
  #@@feeds = []

  def index
    @feeds = get_newsfeeds
    @@feeds = @feeds
  end

  def user_closet
    user = User.find(params[:id]) if params[:id].present?
    #user = User.find(17) if params[:id].present?
    if session[:webview] == '1'
      render :partial => 'user_closet', :locals => {:@user => user}
    else
      render :partial => '/desktop/users/closet', :locals => {:@user => user}
    end
  end

  def profile
    @user = current_user
    render :partial => 'user_profile', :locals => {:@user => @user}
  end

  def notifications_update
    notif_settings = current_user.notification_setting
    notif_settings.update_attribute(params[:setting], params[:state])
    render :partial => 'notification_setting_edit', :locals => {:@notifications => current_user.notification_setting}
  end

  def picture_update
    if params[:user_id].present?
      user = User.find(params[:user_id])
      user.update_attributes(:avatar => params[:user][:avatar]) if user.present?
      render :partial => 'user_profile', :locals => {:@user => user}
    else
      render :text => 'error'
    end
  end

  def picture_update_android
    if params[:user_id].present?
      user = User.find(params[:user_id])
      # user.update_attributes(:avatar => ) if user.present?
      user.avatar = File.new("#{Rails.root}/tmp/temp_item.jpg")
      user.save!
      render :partial => 'user_profile', :locals => {:@user => user}
    else
      render :text => 'error'
    end
  end

  def aboutme_update
    if params[:user_id].present?
      user = User.find(params[:user_id])
      url = user.user_feed.url
      user.update_attributes(:about_me => params[:user][:about_me]) if user.present?
      user_feed = user.user_feed if user.user_feed.present?
      user_feed.update_attributes(:url => params[:user][:user_feed_attributes][:url], :feed_title => params[:user][:user_feed_attributes][:feed_title])
      if params[:user][:user_feed_attributes][:url] != url
        user_feed.update_attributes(:is_active => 2)
      end
      render :partial => 'user_profile', :locals => {:@user => user}
    else
      render :text => 'error'
    end
  end

  def password_update
    if params[:user_id].present?
      user = User.find(params[:user_id])
      if user.valid_password?(params[:Old_Password])
        user.update_attributes(:password => params[:user][:password]) if user.present?
        sign_in user, :bypass => true
        render :partial => 'user_profile', :locals => {:@user => user}
      else
        render :text => 'wrong'
      end
    else
      render :text => 'error'
    end
  end

  def location_update
    if params[:user_id].present?
      user = User.find(params[:user_id])
      user.update_attributes(:location => params[:location]) if user.present?
      render :partial => 'location_edit', :locals => {:@user => user, :@locations => @@locations}
    else
      render :text => 'error'
    end
  end

  def profile_update
    if params[:user_id].present?
      user = User.find(params[:user_id])
      user1 = User.where(:user_name => params[:user][:user_name]).where.not(:id => params[:user_id]).first
      user2 = User.where(:email => params[:user][:email]).where.not(:id => params[:user_id]).first
      if user1.blank? && user2.blank?
        user.skip_reconfirmation!
        #user.update_attributes(:first_name => params[:user][:first_name], :last_name => params[:user][:last_name]) if user.present?
        user.update(user_params) if user.present?
        render :partial => 'user_profile', :locals => {:@user => user}
      else
        render :text => 'present'
      end
    else
      render :text => 'error'
    end
  end

  def goto_profile_pic
    render :partial => 'profile_pic_edit', :locals => {:@user => current_user}
  end

  def goto_profile
    render :partial => 'profile_edit', :locals => {:@user => current_user}
  end

  def goto_aboutme
    render :partial => 'aboutme_edit', :locals => {:@user => current_user}
  end

  def goto_password
    render :partial => 'password_edit', :locals => {:@user => current_user}
  end

  def goto_location
    render :partial => 'location_edit', :locals => {:@user => current_user, :@locations => @@locations}
  end

  def linked_accounts
    render :partial => 'linked_accounts', :locals => {:user => current_user, :accounts => @@socials}
  end

  def media_detail
    render :partial => 'unlink_accounts', :locals => {:user => current_user, :media => @@socials[params[:index].to_i]}
  end

  def unlink_account
    if params[:media].present?
      media = current_user.authorizations.where(:provider => params[:media]).first
      media.destroy if media.present?
      render :text => 'ok'
    else
      render :text => 'error'
    end
  end

  def goto_notification
    render :partial => 'notification_setting_edit', :locals => {:@notifications => current_user.notification_setting}
  end

  def back_to_setting
    render :partial => 'user_profile', :locals => {:@user => current_user}
  end

  def static_pages
    if session[:webview] == '1'
      #if params[:page] == 'about_adoorn'
      #  render :partial => 'about_adoorn'
      #elsif params[:page] == 'privacy_policy'
      #  render :partial => 'privacy_policy'
      #elsif params[:page] == 'terms_of_services'
      #  render :partial => 'terms_of_services'
      #elsif params[:page] == 'feedback'
      render :partial => "#{params[:page]}"
      #end
    else
      render :partial => "/desktop/users/#{params[:page]}"
    end
  end

  def check_email
    @user = User.where(:email => params[:user][:email]).first
    render :text => "true" if @user.blank?
    render :text => "false" if @user.present?
  end

  def check_email_admin
    unless params[:user][:email].blank?
      @user = User.where(:email => params[:user][:email]).first
      render :text => "true" if @user.blank?
      render :text => "false" if @user.present?
    else
      render :text => "true"
    end
  end

  def check_username
    @user = User.where(:user_name => params[:user][:user_name]).first
    render :text => "true" if @user.blank?
    render :text => "false" if @user.present?
  end

  def user_name_check
    @user = User.where(:user_name => params[:user][:user_name]).first
    render :text => "true" and return if @user.blank?
    if @user.user_name == current_user.user_name
      render :text => "true" if @user.present?
    else
      render :text => "false" if @user.present?
    end
  end

  def user_email_check
    @user = User.where(:email => params[:user][:email]).first
    render :text => "true" and return if @user.blank?
    if @user.email == current_user.email
      render :text => "true" if @user.present?
    else
      render :text => "false" if @user.present?
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :user_name, :about_me, :location, :avatar, :password, :password_confirmation, :current_password, :email, :user_name)
  end

  def notification_params
    params.require(:notification_setting).permit(:new_adoorns, :mentions, :item_adoorns, :outfit_adoorns, :special_offers, :editor_recommendations)
  end

  def user_adoorners
    user = User.find(params[:id]) if params[:id].present?
    @adoorners = user.adoorners if user.present?
  end

  def adoorners
    @adoorners = []
    user = User.find(params[:id]) if params[:id].present?
    @adoorners = user.adoorners if user.present?
    render :partial => "user_adoorners", :locals => {:@adoorners => @adoorners, :@user => user}
  end

  def adoornings
    @adoorns = []
    user = User.find(params[:id]) if params[:id].present?
    @adoorns = user.iadoorns if user.present?
    render :partial => "user_adoornings", :locals => {:@adoorns => @adoorns, :@user => user}
  end

  def user_adoorns
    user = User.find(params[:id]) if params[:id].present?
    @adoorns = user.iadoorns if user.present?
  end

  def user_adoorned
    user = User.find(params[:id]) if params[:id].present?
    items = UserItem.all.map { |i| i if i.item_adoorners.include?(user.id) }
    outfits = UserOutfit.all.map { |i| i if i.outfit_adoorners.include?(user.id) }
    items.reject! { |c| c.nil? }
    outfits.reject! { |c| c.nil? }
    @adoorned = (items + outfits).sort_by { |feed| feed.created_at }.reverse
    if session[:webview] == '1'
      render :partial => 'user_adoorned', :locals => {:@adoorned => @adoorned, :@user => user}
    else
      render :partial => '/desktop/users/adoored_list', :locals => {:@adoorned => @adoorned, :@user => user}
    end
  end

  def user_mentions
    user = User.find(params[:id]) if params[:id].present?
    @mentions = get_mentions(user)
  end

  def mentions
    user = User.find(params[:id]) if params[:id].present?
    @mentions = get_mentions(user)
    render :partial => 'user_mentions', :locals => {:@mentions => @mentions, :@user => user}
  end

  def show
    @user = User.where(:id => params[:id]).first
  end

  def add_adoorn
    user = User.find(params[:id]) if params[:id].present?
    if params[:status] == "true"
      adoorner = UserAdoorner.where(:adoorner_id => current_user.id, :user_id => user.id).first
      adoorner.destroy if adoorner.present?
      user.mentions.where(:by_user => current_user.id).destroy_all
    elsif params[:status] == "false"
      adoorn_user(current_user.id, params[:id]) if params[:id].present?
    end
    if session[:webview] == '1'
      render :partial => "user_closet", :locals => {:@user => user}
    else
      render :partial => "/desktop/users/closet", :locals => {:@user => user}
    end
  end

  def search_users
    users, items =[], []
    if params[:type] == 'user'
      users = User.joins(:role_user => [:role]).where(:roles => {:title => 'user'}).where("user_name LIKE ? OR first_name LIKE ? OR last_name LIKE ? ", "%#{params[:key]}%", "%#{params[:key]}%", "%#{params[:key]}%")
      users = users.where("isactive = ? AND hide_as_user = ?", true, false)
    elsif params[:type] == 'item'
      items = UserItem.where("title LIKE ? OR description LIKE ? AND is_active = ?", "%#{params[:key]}%", "%#{params[:key]}%", true)
      #items = items.order(:price => :desc)
    end
    if RecentSearch.where(:search => params[:key], :user_id => current_user.id).first.nil?
      RecentSearch.create!(:search => params[:key], :user_id => current_user.id)
    else
      rec = RecentSearch.where(:search => params[:key], :user_id => current_user.id).first
      rec.update_attributes(:updated_at => Time.now)
    end
    render :partial => params[:type] + '_results', :locals => {:users => users, :items => items}
  end

  def news_feed
    @feeds = get_newsfeeds
    @@feeds = @feeds
    if session[:webview] == '1'
      render "#{Rails.root}/app/views/user/users/news_feed", :layout => 'application'
    else
      render '/desktop/users/index', :layout => 'desktop'
    end
  end

  def newsfeed_partial
    feeds = get_newsfeeds
    if feeds.present?
      @@feeds = feeds
      render :partial => 'news_feed_partial', :locals => {:@feeds => feeds}
    else
      render :text => 'error'
    end
  end


  def update_newsfeed
    feeds = get_newsfeeds
    if feeds.present?
      updated = (feeds - @@feeds)
      @@feeds = feeds
      #if updated.last.created_at > @@feeds.first.created_at
      #  p "YES"
      #else
      #  p "NO"
      #end
      #puts "AAAAAAAAAAAAAAAAAAAAAAAAA", updated.inspect
      render :partial => 'feeds_items', :locals => {:@feeds => updated}
    else
      render :text => 'error'
    end
  end

  #def add_feed_url
  #  user_feed = UserFeed.find(params[:id]) if params[:id].present?
  #  if user_feed.present?
  #    user_feed.update_attributes(user_feed_params)
  #  else
  #    UserFeed.create!(user_feed_params)
  #  end
  #  render :partial => 'user_profile', :locals => {:@user => current_user}
  #end

  def search_partial
    @recent = current_user.recent_searches.where(:search_type => nil).order(:updated_at => :desc).limit(10).uniq
    render :partial => 'search_partial', :locals => {:@recent => @recent}
  end

  def searching
    @recent = current_user.recent_searches.where(:search_type => nil).order(:created_at => :desc).limit(10).uniq
    users = User.joins(:role_user => [:role]).where(:roles => {:title => 'user'}).where("user_name LIKE ? OR first_name LIKE ? OR last_name LIKE ?AND isactive = ?", "%#{params[:key]}%", "%#{params[:key]}%", "%#{params[:key]}%", true)
    users = users.where("isactive = ? AND hide_as_user = ?", true, false)
    render :partial => "/desktop/users/desk_search_partial", :locals => {:@recent => @recent, :users => users}
  end

  def desk_search
    users, items =[], []
    if params[:type] == 'user'
      users = User.joins(:role_user => [:role]).where(:roles => {:title => 'user'}).where("user_name LIKE ? OR first_name LIKE ? OR last_name LIKE ? AND isactive = ?", "%#{params[:key]}%", "%#{params[:key]}%", "%#{params[:key]}%", true)
      users = users.where("isactive = ? AND hide_as_user = ?", true, false)
    elsif params[:type] == 'item'
      items = UserItem.where("title LIKE ? OR description LIKE ? AND is_active = ?", "%#{params[:key]}%", "%#{params[:key]}%", true)
      #items = items.order(:price => :desc)
    end
    RecentSearch.create!(:search => params[:key], :user_id => current_user.id) if RecentSearch.where(:search => params[:key], :user_id => current_user.id).first.nil?
    render :partial => '/desktop/users/' + params[:type] + '_results', :locals => {:users => users, :items => items}
  end

  def edit_pass
    @resource = User.find(params[:id]) if params[:id].present?
    @token = params[:token] if params[:token].present?
    if request.env['HTTP_USER_AGENT'].downcase.match(/iphone/) != nil
      url = edit_password_url(@resource, :reset_password_token => @token)
      url.slice!('http://')
      redirect_to 'Adoorn://' + url
    else
      redirect_to edit_password_url(@resource, :reset_password_token => @token)
    end
  end

  def reporting
    if params[:content_type] == 'user'
      content = User.find(params[:id])
    elsif params[:content_type] == 'item'
      content = UserItem.find(params[:id])
    elsif params[:content_type] == 'outfit'
      content = UserOutfit.find(params[:id])
    else
      content = UserBlog.find(params[:id])
    end
    if params[:comment] == 'true'
      render :partial => 'y_reporting', :locals => {:content_type => params[:content_type], :content => content}
    else
      render :partial => 'reporting', :locals => {:content_type => params[:content_type], :content => content}
    end
  end

  def y_reporting
    if (params[:content_type] == 'user')
      user = User.find(params[:id]) if params[:id].present?
      Report.create(:comment => params[:comment], :by_user => current_user.id, :user_id => params[:id], :is_viewed => false)
      send_report(params[:comment], current_user, user, 'user')
      user_closet
    elsif (params[:content_type] == 'item')
      item = UserItem.find(params[:id]) if params[:id].present?
      Report.create(:comment => params[:comment], :by_user => current_user.id, :user_item_id => params[:id], :is_viewed => false)
      send_report(params[:comment], current_user, item, 'item')
      news_feed
    elsif (params[:content_type] == 'outfit')
      outfit = UserOutfit.find(params[:id]) if params[:id].present?
      Report.create(:comment => params[:comment], :by_user => current_user.id, :user_outfit_id => params[:id], :is_viewed => false)
      send_report(params[:comment], current_user, outfit, 'outfit')
      news_feed
    else
      blog = UserBlog.find(params[:id]) if params[:id].present?
      Report.create(:comment => params[:comment], :by_user => current_user.id, :user_blog_id => params[:id], :is_viewed => false)
      send_report(params[:comment], current_user, blog, 'blog')
      news_feed
    end
  end

  def feedback
    AdoornMailer.feedback_email(current_user, params[:feedback]).deliver
    back_to_setting
  end

  def desk_reporting
    if (params[:content_type] == 'outfit')
      outfit = UserOutfit.find(params[:id]) if params[:id].present?
      Report.create(:comment => params[:comment], :by_user => current_user.id, :user_outfit_id => params[:id], :is_viewed => false)
      send_report(params[:comment], current_user, outfit, 'outfit')
    elsif (params[:content_type] == 'item')
      item = UserItem.find(params[:id]) if params[:id].present?
      Report.create(:comment => params[:comment], :by_user => current_user.id, :user_item_id => params[:id], :is_viewed => false)
      send_report(params[:comment], current_user, item, 'item')
    elsif (params[:content_type] == 'user')
      user = User.find(params[:id]) if params[:id].present?
      Report.create(:comment => params[:comment], :by_user => current_user.id, :user_id => params[:id], :is_viewed => false)
      send_report(params[:comment], current_user, user, 'user')
    end
    render :text => ''
  end

  private

  def send_report(text, by_user, user, type)
    AdoornMailer.reporting_email(text, by_user, user, type).deliver
  end

  def user_user?
    if user_signed_in?
      redirect_to '/users/sign_out' unless current_user.user?
    else
      redirect_to '/users/sign_in'
    end
  end

  def user_feed_params
    params.require(:user_feed).permit(:url, :user_id)
  end

  def adoorn_user(uid, id)
    adoorner = UserAdoorner.create(:adoorner_id => uid, :user_id => id) if id.present?
    Mention.create(:user_id => id, :by_user => uid, :content_type => 'user', :mention_type => 'adoorning') if adoorner.present?
  end

  def get_newsfeeds
    adoornings = current_user.adoorning_ids
    #items = UserItem.where("user_id IN (?) AND private_flag=? AND is_active=?", adoornings, false, true).order("created_at DESC").limit(15)
    items = UserItem.where("user_id IN (?) AND private_flag=? AND is_active=?", adoornings, false, true).order("created_at DESC").limit(15)
    outfits = UserOutfit.where("user_id IN (?) AND private_flag=? AND is_active=?", adoornings, false, true).order("created_at DESC").limit(15)
    items = items + current_user.user_items
    outfits = outfits + current_user.user_outfits
    @feeds = []
    unless items.blank?
      items.map { |item| @feeds << item }
    end
    unless outfits.blank?
      outfits.map { |outfit| @feeds << outfit }
    end
    @feeds = @feeds.sort_by { |feed| feed.created_at }.reverse.take(15)
    return @feeds
  end

  def get_mentions(user)
    @mentions = []
    user.unread_mentions.each do |mention|
      by = User.find(mention.by_user)
      content = UserBlog.find(mention.content_id) if mention.content_type == 'blog'
      content = UserOutfit.find(mention.content_id) if mention.content_type == 'outfit'
      content = UserItem.find(mention.content_id) if mention.content_type == 'item'
      content = current_user if mention.content_type == 'user'
      clik = "view_partial('icon_closet','/user/users/user_closet?id=#{by.id}')"
      usr_clik = "view_partial('icon_closet','/user/users/user_closet?id=#{current_user.id}')"
      if mention.content_type == 'user'
        @mentions << "<a href='javascript:;' onclick=#{clik}><div class='user-image2'><img src='#{File.exists?(by.avatar.path(:thumb).to_s) ? by.avatar(:thumb) : '/assets/missing.jpg'}'></div></a><div class='descrip'><div class='txtbx'><a href='javascript:;' onclick=#{clik}>#{by.user_name.truncate(25)} </a><span> started #{mention.mention_type} <a href='javascript:;' onclick=#{usr_clik}>#{current_user.id == mention.user_id ? 'you' : user.user_name.truncate(25)}.</a></span></div><div class='days'>#{time_ago_in_words(mention.created_at)} ago</div></div><div class='mn-pro'></div>".html_safe
        #@mentions << "<img src='#{File.exists?(by.avatar.path(:thumb).to_s) ? by.avatar(:thumb) : '/assets/missing.jpg'}' class='avatar'> <a href='/user/show/#{by.id.to_s}'>#{by.user_name}</a> started #{mention.mention_type} <a href='/user/show/#{current_user.id}'>you</a>..".html_safe
      else
        iclik = "get_partial('#{content.id}',"+"'/user/user_#{mention.content_type}s/show')"
        @mentions << "<a href='javascript:;' onclick=#{clik}><div class='user-image2'><img src='#{File.exists?(by.avatar.path(:thumb).to_s) ? by.avatar(:thumb) : '/assets/missing.jpg'}'></div></a><div class='descrip'><div class='txtbx'><a href='javascript:;' onclick=#{clik}>#{by.user_name.truncate(25)} </a><span> #{mention.mention_type} #{current_user.id == mention.user_id ? 'your' : user.user_name.truncate(25)+'\'s'} #{mention.content_type} <a href='javascript:;' onclick=#{iclik}>#{content.title}</a></span></div><div class='days'>#{time_ago_in_words(mention.created_at)} ago</div></div><div class='mn-pro'><a href='#'><img src='#{File.exists?(content.image.path(:thumb).to_s) ? content.image(:thumb) : '/assets/missing_item.jpeg'}' alt=''></a></div>".html_safe
        #@mentions << "<img src='#{File.exists?(by.avatar.path(:thumb).to_s) ? by.avatar(:thumb) : '/assets/missing.jpg'}' class='avatar'> <a href='/user/show/#{by.id.to_s}'>#{by.user_name}</a> #{mention.mention_type} your #{mention.content_type} <a href='/user/item/show/#{content.id}'>#{content.title}</a>..".html_safe
      end
    end
    return @mentions
  end

end
