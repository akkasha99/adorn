class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery :with => :exception
  before_action :route_user, :except => [:edit_pass, :android_image_up]
  before_action :configure_permitted_parameters, :if => :devise_controller?
  before_filter :delete_signed_in_token_if_logged_out
  @@feeds = []

  def after_sign_in_path_for(resource)
    if current_user.admin?
      '/admin/dashboard'
    elsif current_user.user?
      '/newsfeed'
    else
      '/users/sign_in'
    end
  end

  private

  def check_platform
    session[:webview] = '1';
    if request.headers["ADOORNWEBVIEW"] == 'true' || session[:webview] == '1'
      session[:webview] = '1';
    else
      session[:webview] = '0';
    end
  end

  def route_user
    if user_signed_in?
      admin_path unless current_user.admin?
      user_path unless current_user.user?
    else
      '/users/sign_in'
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:user_name, :password, :remember_me) }
  end

  def delete_signed_in_token_if_logged_out
    unless current_user.present?
      cookies.delete :signed_in
    end
  end

  def post_to_socials(socials, item)
    puts "social s" , socials.inspect
    puts "items ------- " , item.inspect
    socials.each do |media|
      puts "media  -- "  , media.inspect
      if media == 'facebook' && check_connection(media)
        puts "jjjjjjjjjjjjjjjj"
        fb_post(item)
      elsif media == 'twitter' && check_connection(media)
        p "Twitter"
        if Rails.env.production?
          access_token = prepare_access_token(current_user.authorizations.where(:provider => 'Twitter').first.token, current_user.authorizations.where(:provider => 'Twitter').first.secret)
          #@response = @access_token.post("https://api.twitter.com/1.1/statuses/update_with_media.json", {:status => "stat"})
          response = access_token.post("https://api.twitter.com/1.1/statuses/update.json", {:status => "http://54.94.234.54" + item.image.url(:thumb).to_s})
        end
      elsif media == 'instagram' && check_connection(media)
        p "Instagram"
      elsif media == 'tumblr' && check_connection(media)
        tumblr_post(item)
      end
    end
  end

  def fb_post(item)
    puts "inside fb post"
    if Rails.env.production?
      puts "fb post in production mode"
      token = current_user.authorizations.where(:provider => 'Facebook').first.token
      me = FbGraph::User.me(token)
      if me.permissions.include?(:publish_actions)
        album = me.albums.detect { |album| album.name == 'Adoorn' }
        if album.nil?
          album = me.album!(:name => "Adoorn")
        end
        album.photo!(
            #:source => File.new(File.join(File.dirname(__FILE__), 'fb_graph.png'), 'rb'), # 'rb' is needed only on windows
            #:url => "http://54.94.234.54/system/images/31/other/outfit.png?1422920349",
            :url => "http://54.94.234.54" + item.image.url(:thumb).to_s,
            :message => "#adoornit"
        )
        puts "Fb post end"
      end
    end
  end

  def tumblr_post(item)
    Tumblr.configure do |config|
      config.consumer_key = "skT1ExukL4jR2kZJ197mMxy1QE9lyXFEIqFNIhKKASWnG3xHZ2"
      config.consumer_secret = "VWRdtOHMaq3l9ut4ov5egdJVvXMYETQ1Q4oYdP5oyfiTAw0hDM"
      config.oauth_token = current_user.authorizations.where(:provider => 'tumblr').first.token
      config.oauth_token_secret = current_user.authorizations.where(:provider => 'tumblr').first.secret
    end
    client = Tumblr::Client.new
    username = current_user.authorizations.where(:provider => 'tumblr').first.uid
    client.photo("#{username}.tumblr.com", {:caption => "#adoornit", :data => ["#{item.image.path(:other)}"], :tags => '#adoornit'})
    #client.photo("#{username}.tumblr.com", {:link => ['54.94.234.54/system/images/52/other/temp_item.jpeg?1423840164']})
  end

  def prepare_access_token(oauth_token, oauth_token_secret)
    consumer_key = TWITTER_KEY
    consumer_secret = TWITTER_SECRET
    consumer = OAuth::Consumer.new(consumer_key, consumer_secret,
                                   {:site => "http://api.twitter.com",
                                    :scheme => :header
                                   })
    token_hash = {:oauth_token => oauth_token,
                  :oauth_token_secret => oauth_token_secret
    }
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash)
    return access_token
  end

  def check_connection(provider)
    if current_user.has_connection_with(provider)
      #html = link_to disconnect_path(social: provider.downcase), class: "#{provider}-m phone-verified row" do
      #  content_tag :span, 'Verified', class: "verified"
      #end
      true
    else
      #html = link_to user_omniauth_authorize_path(provider: provider.downcase), class: "#{provider}-m phone-verified row" do
      #  content_tag :span, 'Click to verify', class: "un-verified"
      #end
      false
    end
  end
end
