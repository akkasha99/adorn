require 'rss'
class User::UserBlogsController < ApplicationController

  def index
    @blogs = UserBlog.where(:private_flag => false, :is_active => true).map { |i| i if i.blog_adoorners.include?(current_user.id) }
    @blogs.reject! { |c| c.nil? }
    @recent = current_user.recent_searches.where(:search_type => 'blog').order(:created_at => :desc).limit(10).uniq
  end

  def blogs_index
    adoornings = current_user.adoorning_ids
    @blogs
    unless adoornings.blank?
      @blogs = UserBlog.where("user_id IN (?) AND private_flag=? AND is_active=?", adoornings, false, true).order("created_at DESC").limit(15)
      #abc = UserAdoorner.where(:adoorner_id => current_user.id).map { |i| i.user_id }
      #@blogs = UserBlog.where(:private_flag => false, :is_active => true).map { |i| i if i.blog_adoorners.include?(current_user.id) }
      #@blogs.reject! { |c| c.nil? }
    end
    @recent = current_user.recent_searches.where(:search_type => 'blog').order(:created_at => :desc).limit(10).uniq
    render :partial => 'bloggers_partial'
  end

  def show
    @blog = UserBlog.find(params[:id]) if params[:id].present?
    render :partial => 'blog_show'
  end

  def i_adoor
    adoornings = current_user.adoorning_ids
    @blogs = UserBlog.where("user_id IN (?) AND private_flag=? AND is_active=?", adoornings, false, true).order("created_at DESC")
    @recent = current_user.recent_searches.where(:search_type => 'blog').order(:created_at => :desc).limit(10).uniq
    if session[:webview] == '1'
      #@blogs = UserBlog.where(:private_flag => false, :is_active => true).map { |i| i if i.blog_adoorners.include?(current_user.id) }
      #@blogs.reject! { |c| c.nil? }
      render :partial => 'iadoor_blogs', :locals => {:@blogs => @blogs.limit(15)}
    else
      render :partial => '/desktop/users/blogs_list', :locals => {:@blogs => @blogs}
    end
  end

  def we_adoor
    bloggers = User.where(:is_featured => true, :isactive => true)
    render :partial => 'weadoor_bloggers', :locals => {:@bloggers => bloggers}
  end

  def search_user_blogs
    #blogs = UserBlog.where("title LIKE ? AND is_active = ? AND private_flag = ?", "%#{params[:key]}%", true, false)
    @bloggers = nil
    bloggers_we = []
    bloggers_we = UserFeed.where("url LIKE ? OR feed_title LIKE ? ", "%#{params[:key]}%", "%#{params[:key]}%").map { |u| u.user }
    #unless bloggers_we.blank?
    @bloggers = User.where("isactive=? AND (first_name LIKE ? OR last_name LIKE ?)", true, "%#{params[:key]}%", "%#{params[:key]}%")
    # puts "klasdjfhasdkljfhaskdlfhf", @bloggers.inspect
    #end
    results = []
    bloggers_we.map { |b| results.push(b) } if bloggers_we.length > 0
    @bloggers.map { |b| results.push(b) } if @bloggers.length > 0


    RecentSearch.create!(:search => params[:key], :user_id => current_user.id, :search_type => 'blog') if RecentSearch.where(:search => params[:key], :user_id => current_user.id).first.nil? && params[:key] != ''
    render :partial => 'blog_search_results', :locals => {:@bloggers => results.uniq}
  end

  def complete_search
    if params[:type] == "blog"
      blogs = UserBlog.where("title LIKE ? AND is_active = ? AND private_flag = ?", "%#{params[:key]}%", true, false)
      RecentSearch.create!(:search => params[:key], :user_id => current_user.id, :search_type => 'blog') if RecentSearch.where(:search => params[:key], :user_id => current_user.id).first.nil? && params[:key] != ''
      render :partial => 'blogs_result', :locals => {:blogs => blogs}
    else
      @bloggers = nil
      bloggers_we = []
      bloggers_we = UserFeed.where("url LIKE ? OR feed_title LIKE ? ", "%#{params[:key]}%", "%#{params[:key]}%").map { |u| u.user }
      #unless bloggers_we.blank?
      @bloggers = User.where("isactive=? AND (first_name LIKE ? OR last_name LIKE ?)", true, "%#{params[:key]}%", "%#{params[:key]}%")
      # puts "klasdjfhasdkljfhaskdlfhf", @bloggers.inspect
      #end
      results = []
      bloggers_we.map { |b| results.push(b) } if bloggers_we.length > 0
      @bloggers.map { |b| results.push(b) } if @bloggers.length > 0

      RecentSearch.create!(:search => params[:key], :user_id => current_user.id, :search_type => 'blog') if RecentSearch.where(:search => params[:key], :user_id => current_user.id).first.nil? && params[:key] != ''
      render :partial => 'bloggers_result', :locals => {:@bloggers => results.uniq}
    end
  end

  #def index
  #  rss = RSS::Parser.parse('http://www.thatspeachy.com/feeds/posts/default', false)
  #  p "aaaaaaaaaaaaaaaaa", rss.items.first
  #  urls = %w[http://www.thatspeachy.com/feeds/posts/default]
  #  feeds = Feedjira::Feed.fetch_and_parse urls
  #  feed = feeds['http://www.thatspeachy.com/feeds/posts/default']
  #  p "bbbbbbbbbbbbbb", feed.entries.first
  #  xxxxxxxxxxx
  #end

  def blog_adoorning
    blog = UserBlog.find(params[:blog_id]) if params[:blog_id].present?
    if blog.is_adoorned(params[:user_id])
      adorn = Adorn.where(:user_id => current_user.id, :user_blog_id => blog.id).first
      mention = Mention.where(:by_user => current_user.id, :content_type => 'blog', :content_id => blog.id).first if current_user.id != blog.user_id
      adorn.destroy if adorn.present?
      mention.destroy if mention.present?
    else
      Adorn.create(:user_id => current_user.id, :user_blog_id => blog.id) if blog.id.present?
      Mention.create(:user_id => blog.user_id, :by_user => current_user.id, :content_type => 'blog', :mention_type => 'adoorned', :content_id => params[:blog_id]) if blog.present? && current_user.id != blog.user_id
    end
    if session[:webview] == '1'
      render :partial => 'blog_view', :locals => {:blog => blog, :@div => (params[:div] if params[:div].present?)}
    else
      render :partial => '/desktop/users/blog_buttons', :locals => {:blog => blog}
    end
  end

  def comments
    blog = UserBlog.find(params[:id]) if params[:id].present?
    @comments = blog.comments
    @blog_id = params[:id]
    if session[:webview] == '1'
      render :partial => 'comments'
    else
      render :partial => '/desktop/users/blog_comment', :locals => {:comment => @comments, :blog => blog}
    end
  end

  def add_comments
    blog= UserBlog.where(:id => params[:id]).first
    Mention.create(:user_id => blog.user_id, :by_user => current_user.id, :content_type => 'blog', :mention_type => 'commented', :content_id => params[:id]) if blog.present? && current_user.id != blog.user_id
    Comment.create(comment_params)
    comments
  end

  def search_blogs
    users = User.joins(:role_user => [:role]).where(:roles => {:title => 'user'}).where("user_name LIKE ? OR first_name LIKE ? OR last_name LIKE ? AND isactive = ?", "%#{params[:key]}%", "%#{params[:key]}%", "%#{params[:key]}%", true)
    users = users.map { |u| u if u.user_feed.present? } if users.present?
    render :partial => 'search_blogs', :locals => {:users => users}
  end

  def blogs_list
    user = User.where(:id => params[:user_id]).first if params[:user_id].present?
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
      @blogs = user.user_blogs.where(:is_active => true, :private_flag => false).order("created_at ASC") if user.present?
      @blogs = @blogs.reverse
    else
      @blogs = nil
    end
    if session[:webview] == '1'
      render :partial => 'user_blogs', :locals => {:@blogs => @blogs, :@user => user}
    else
      if params[:current_user_blogs].present?
        render :partial => '/desktop/users/user_blogs', :locals => {:@blogs => @blogs, :@user => user}
      else
        render :partial => '/desktop/users/blogs_list', :locals => {:@blogs => @blogs, :@user => user}
      end
    end
  end

  def blogger_blogs
    user = User.find(params[:id])
    blogs = user.user_blogs
    render :partial => 'blogger_blogs', :locals => {:@blogs => blogs.take(50)}
  end

  def blogger_adoorn
    user = User.find(params[:id]) if params[:id].present?
    if params[:status] == "true"
      adoorner = UserAdoorner.where(:adoorner_id => current_user.id, :user_id => user.id).first
      adoorner.destroy if adoorner.present?
      user.mentions.where(:by_user => current_user.id).destroy_all
    elsif params[:status] == "false"
      adoorner = UserAdoorner.create(:adoorner_id => current_user.id, :user_id => params[:id]) if params[:id].present?
      Mention.create(:user_id => params[:id], :by_user => current_user.id, :content_type => 'user', :mention_type => 'adoorning') if adoorner.present?
    end
    if params[:we]== '0'
      render :partial => "we_adoor_blogger", :locals => {:blogger => user}
    else
      render :partial => "adoorn_it", :locals => {:user => user}
    end
  end

  #def view_blog_detail
  #  puts "ASASASAS", params.inspect
  #  render :partial => 'view_blog_detail'
  #end

  private

  def comment_params
    params.require(:comment).permit(:text, :user_id, :user_item_id, :user_blog_id, :user_outfit_id)
  end

  def new_feeds(urls, user)
    feeds = Feedjira::Feed.fetch_and_parse urls
    urls.each do |url|
      feed = feeds[url]
      blogs = feed.entries
      blogs.each do |blog|
        unless user.user_blogs.where(:identifier => blog.entry_id).first.present?
          UserBlog.create!(:title => blog.title, :content => (blog.content.present? ? blog.content : blog.summary), :identifier => blog.entry_id, :web_link => blog.url, :user_id => user.id, :created_at => blog.published)
        end
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
