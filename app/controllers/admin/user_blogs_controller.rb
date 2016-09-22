class Admin::UserBlogsController < Admin::AdminsController

  def index
    users = User.all.map { |u| u if (u.isactive == true && !u.admin?) }.compact!
    render :partial => 'user_blogs', :locals => {:users => users}
  end

  def new
    render :partial => 'new_user', :locals => {:@user => User.new}
  end

  def create
    # if user1.blank? && user2.blank?
    @user = User.new(user_params)
    @user.skip_confirmation!
    if @user.save!
      role = Role.where(:title => "user").first
      @user.role = role
      NotificationSetting.create(:user_id => @user.id)
      all_bloggers
    else
      new
    end
    # else
    #   render :text => 'present'
    # end
  end

  def get_user_blogs
    user = User.find(params[:id]) if params[:id].present?
    blogs = (user.present? ? user.user_blogs : [])
    feed = user.user_feed if user.user_feed.present?
    blogs = []
    blogs = user.user_blogs
    render :partial => 'blogs_partial', :locals => {:items => blogs, :user_id => (user.id if user.present?), :feed => feed, :blogs => blogs, :user => user}
  end

  def change_blog_control
    user = User.find(params[:user_id]) if params[:user_id].present?
    blog = UserBlog.find(params[:id]) if params[:id].present?
    if blog.present?
      if blog.is_active == false
        blog.update_attribute('is_active', true)
        rss_feed = user.user_feed if user.isactive == true
        if !rss_feed.nil? && rss_feed.is_active == 1
          urls =[]
          url = rss_feed.url
          urls << url if url.present?
          if @feeds.nil?
            @feeds = new_feeds(urls, user)
          else
            update_feeds(urls, user)
          end
        end
      else
        blog.update_attribute('is_active', false)
      end
    end
    blogs = (user.present? ? user.user_blogs : [])
    render :partial => 'blogs_partial', :locals => {:items => blogs, :user_id => (user.id if user.present?)}
  end

  def block_unblock_feed
    user = User.find(params[:user_id]) if params[:user_id].present?
    feed = user.user_feed if user.user_feed.present?
    if (params[:status]== "1")
      user.user_blogs.each do |blog|
        mention = Mention.where(:content_type => 'blog', :content_id => blog.id)
        mention.each do |mention|
          mention.destroy!
        end
        blog.destroy!
      end
      feed.update_attributes(:is_active => 0)
      AdoornMailer.rejected_blogger(user).deliver
    else
      feed.update_attributes(:is_active => 1)
      rss_feed = user.user_feed if user.isactive == true
      if !rss_feed.nil? && rss_feed.is_active == 1
        urls =[]
        url = rss_feed.url
        urls << url if url.present?
        if @feeds.nil?
          @feeds = new_feeds(urls, user)
        else
          update_feeds(urls, user)
        end
      end
      AdoornMailer.approved_blogger(user).deliver
    end
    user1 = User.find(params[:user_id]) if params[:user_id].present?
    blogs = user1.user_blogs
    if params[:other]== '1'
      render :partial => 'blogs_partial', :locals => {:feed => (user.user_feed if user.user_feed.present?), :user_id => user.id, :blogs => blogs, :user => user}
    else
      bloggers_detail
    end
  end

  def block_unblock_blog
    user = User.find(params[:user_id]) if params[:user_id].present?
    blog = user.user_blogs.where(:id => params[:blog_id]).first
    if (blog.is_active == true)
      blog.update_attributes(:is_active => false)
    else
      blog.update_attributes(:is_active => true)
    end
    render :partial => 'blog_block_button', :locals => {:blog => blog}
  end

  def is_featured
    user = User.where(:id => params[:user_id]).first
    if (user.is_featured == true)
      user.update_attributes(:is_featured => false)
    else
      user.update_attributes(:is_featured => true)
    end
    render :partial => 'is_featured', :locals => {:user => user}
  end

  def edit
    @user = User.find(params[:id]) if params[:id].present?
    render :partial => 'edit_user', :locals => {:@user => (@user if @user.present?)}
  end

  def update
    user = User.find(params[:user_id]) if params[:user_id].present?
    user.skip_reconfirmation!
    user.update_attributes(:avatar => params[:user][:avatar], :first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :location => params[:user][:location], :about_me => params[:user][:about_me], :email => params[:user][:email], :user_name => params[:user][:user_name], :hide_as_user => params[:user][:hide_as_user]) if user.present?
    if user.user_feed.present?
      user_feed = user.user_feed
      pre_feed = user_feed.url
      if params[:user][:user_feed_attributes][:url] != pre_feed
        user_feed.update_attributes(:feed_title => params[:user][:user_feed_attributes][:feed_title], :url => params[:user][:user_feed_attributes][:url], :is_active => 2)
      else
        user_feed.update_attributes(:feed_title => params[:user][:user_feed_attributes][:feed_title])
      end
    end
    all_bloggers
  end

  def bloggers_detail
    inactive = User.all.map { |u| u if (u.isactive == true && u.hide_as_user == false && !u.admin? && u.user_feed.present? && u.user_feed.is_active == 0) }.compact!
    active = User.all.map { |u| u if (u.isactive == true && u.hide_as_user == false && !u.admin? && u.user_feed.present? && u.user_feed.is_active == 1) }.compact!
    pending = User.all.map { |u| u if (u.isactive == true && u.hide_as_user == false && !u.admin? && u.user_feed.present? && u.user_feed.is_active == 2) }.compact!
    render :partial => 'bloggers_detail', :locals => {:inactive => inactive, :active => active, :pending => pending}
  end

  def all_bloggers
    active_users = User.all.map { |u| u if (u.isactive == true && u.hide_as_user == true && u.user?) }.reverse
    inactive_users = User.all.map { |u| u if (u.isactive == false && u.hide_as_user == true && u.user?) }.reverse
    render :partial => 'all_bloggers', :locals => {:@active_users => active_users.compact!, :@inactive_users => inactive_users.compact!}
  end

  private
  def user_params
    #params.require(:user).permit(:first_name, :last_name, :user_name, :email, :password, :password_confirmation, :about_me, :location, :avatar)
    #add blog url at user creation in admin as sub-form
    params.require(:user).permit(:first_name, :last_name, :user_name, :email, :password, :password_confirmation, :about_me, :location, :avatar, :hide_as_user, :user_feed_attributes => [:url, :user_id, :feed_title, :id, :is_active])
  end

  def report_params
    params.require(:user).permit(:by_user, :user_id, :comment, :user_item_id, :user_outfit_id, :user_blog_id)
  end

  def new_feeds(urls, user)
    feeds = Feedjira::Feed.fetch_and_parse urls
    urls.each do |url|
      feed = feeds[url]
      begin
        blogs = feed.entries
        blogs.each do |blog|
          unless user.user_blogs.where(:identifier => blog.entry_id).first.present?
            UserBlog.create!(:title => blog.title, :content => (blog.content.present? ? blog.content : blog.summary), :identifier => blog.entry_id, :web_link => blog.url, :user_id => user.id, :created_at => blog.published)
          end
        end
      rescue
        return []
      end
    end
    return feeds
  end

  def update_feeds(urls, user)
    feeds = Feedjira::Feed.update(@feeds.values)
    urls.each do |url|
      feed = feeds[url]
      if feed.updated?
        @feeds[url] << feed
        blogs = feed.new_entries
        blogs.each do |blog|
          unless user.user_blogs.where(:identifier => blog.entry_id).first.present?
            UserBlog.create!(:title => blog.title, :content => (blog.content.present? ? blog.content : blog.summary), :identifier => blog.entry_id, :web_link => blog.url, :user_id => user.id, :created_at => blog.published)
          end
        end
      end
    end
    return feeds
  end

end
