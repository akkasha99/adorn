namespace :db do

  task :seed_adoorn_blogger => :environment do


    puts "adding Adoorn main blogger"
    role = Role.where(:title => "user").first
    user = User.new(:email => "blogger@adoorn.com", :user_name => 'adoorninc', :hide_as_user => true,:first_name => 'main', :password => "adoorn2014")
    user.avatar = File.open(File.join("#{Rails.root}/db/Adoorn-app-icon-4.jpg"))
    user.skip_confirmation!
    user.save!
    user.role = role

    user_feed = UserFeed.new(:user_id => user.id, :url => "adoorninc.tumblr.com/rss", :feed_title => "Adoorn Blog", :is_active => 1)
    user_feed.save!

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


    puts "fixed"


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
