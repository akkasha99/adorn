class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  require 'uuidtools'

  def facebook
    oauthorize "Facebook"
  end

  def twitter
    oauthorize "Twitter"
  end

  #def linkedin
  #  oauthorize "LinkedIn"
  #end

  def instagram
    oauthorize "instagram"
  end

  def tumblr
    oauthorize "tumblr"
  end

  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

  private

  def oauthorize(kind)
    @user = find_for_ouath(kind, env["omniauth.auth"], current_user)
    role = Role.where(:title => "user").first
    @user.role = role if role.present?
    NotificationSetting.create(:user_id => @user.id)
    if @user
      if current_user.present?
        flash[:notice] = "Account Successfully Linked..."
        redirect_to '/'
      else
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => kind
        #session["devise.#{kind.downcase}_data"] = env["omniauth.auth"]
        sign_in_and_redirect @user, :event => :authentication
      end
    end
  end

  def find_for_ouath(provider, access_token, resource=nil)
    user, email, name, pic, username, uid, auth_attr = nil, nil, nil, nil, nil, {}
    case provider
      when "Facebook"
        uid = access_token['uid']
        email = access_token['info']['email']
        pic = access_token['info']['image']
        username = access_token['info']['first_name']
        auth_attr = {:uid => uid, :token => access_token['credentials']['token'],
                     :secret => nil, :first_name => access_token['info']['first_name'],
                     :last_name => access_token['info']['last_name'], :name => access_token['info']['name'],
                     :link => access_token['extra']['raw_info']['link']}
      when "Twitter"
        uid = access_token['extra']['raw_info']['id']
        name = access_token['extra']['raw_info']['name']
        auth_attr = {:uid => uid, :token => access_token['credentials']['token'],
                     :secret => access_token['credentials']['secret'], :first_name => access_token['info']['first_name'],
                     :last_name => access_token['info']['last_name'], :name => name,
                     :link => "http://twitter.com/#{name}"}
      when 'LinkedIn'
        uid = access_token['uid']
        name = access_token['info']['name']
        auth_attr = {:uid => uid, :token => access_token['credentials']['token'],
                     :secret => access_token['credentials']['secret'], :first_name => access_token['info']['first_name'],
                     :last_name => access_token['info']['last_name'],
                     :link => access_token['info']['public_profile_url']}
      when 'instagram'
        uid = access_token['uid']
        name = access_token['info']['nickname']
        pic = access_token['info']['image']
        username = access_token['info']['nickname']
        auth_attr = {:uid => uid, :token => access_token['credentials']['token'],
                     :secret => access_token['credentials']['secret'], :first_name => access_token['info']['first_name'],
                     :last_name => access_token['info']['last_name'],
                     :link => access_token['info']['public_profile_url'], :name => username}
      when 'tumblr'
        uid = access_token['uid']
        name = access_token['info']['nickname']
        pic = access_token['info']['image']
        username = access_token['info']['nickname']
        auth_attr = {:uid => uid, :token => access_token['credentials']['token'],
                     :secret => access_token['credentials']['secret'], :first_name => access_token['info']['first_name'],
                     :last_name => access_token['info']['last_name'],
                     :link => access_token['info']['public_profile_url'], :name => username != nil ? username : uid}
      else
        raise 'Provider #{provider} not handled'
    end
    if resource.nil?
      if email
        user = find_for_oauth_by_email(email, resource, auth_attr)
      elsif uid && name
        user = find_for_oauth_by_uid(uid, resource, auth_attr)
        if user.nil?
          user = find_for_oauth_by_name(name, resource, auth_attr)
        end
      end
      user.update_attributes(:user_name => username, :avatar => process_uri(pic))
    else
      user = resource
    end
    auth = user.authorizations.find_by_provider(provider)
    if auth.nil?
      auth = user.authorizations.build(:provider => provider)
      user.authorizations << auth
    end
    auth.update_attributes auth_attr

    return user
  end

  def find_for_oauth_by_uid(uid, resource=nil, attr)
    user = nil
    if auth = Authorization.find_by_uid(uid.to_s)
      user = auth.user
    end
    return user
  end

  def find_for_oauth_by_email(email, resource=nil, attr)
    if user = User.find_by_email(email)
      user
    else
      user = User.new(:email => email, :password => Devise.friendly_token[0, 20])
      user.save
      user.skip_confirmation!
    end
    return user
  end

  def find_for_oauth_by_name(name, resource=nil, attr)
    if user = User.where(:user_name => name).first
      user
    else
      first_name = name
      last_name = name
      user = User.new(:first_name => first_name, :last_name => last_name, :password => Devise.friendly_token[0, 20], :email => "#{UUIDTools::UUID.random_create}@host")
      user.save(:validate => false)
      user.skip_confirmation!
    end
    return user
  end

  #def facebook
  #  # You need to implement the method below in your model (e.g. app/models/user.rb)
  #  @user = User.from_omniauth(request.env["omniauth.auth"])
  #  role = Role.where(:title => "user").first
  #  @user.role = role if role.present?
  #  NotificationSetting.create(:user_id => @user.id)
  #  if @user.persisted?
  #    sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
  #    #set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
  #  else
  #    session["devise.facebook_data"] = request.env["omniauth.auth"]
  #    redirect_to new_user_registration_url
  #  end
  #end

  def process_uri(uri)
    if uri != nil
      avatar_url = URI.parse(uri)
      avatar_url.scheme = 'https'
      avatar_url.to_s
    end
  end
end
