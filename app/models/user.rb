class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:facebook, :twitter, :instagram, :tumblr]


  has_and_belongs_to_many :adoorners, :class_name => "User",
                          :join_table => "user_adoorners",
                          :association_foreign_key => "adoorner_id"

  has_one :role, :through => :role_user
  has_one :role_user
  has_one :notification_setting #, :dependent => :destroy
  has_many :adorns, :dependent => :destroy
  has_many :authorizations, :dependent => :destroy
  has_many :fav_brands, :dependent => :destroy
  has_many :mentions, :dependent => :destroy
  #has_many :user_adoorners
  has_many :recent_searches, :dependent => :destroy
  has_many :user_blogs, :dependent => :destroy
  has_many :user_bloggers, :dependent => :destroy
  has_many :user_items, :dependent => :destroy
  has_many :user_outfits, :dependent => :destroy
  has_one :user_feed, :dependent => :destroy
  accepts_nested_attributes_for :user_feed

  has_attached_file :avatar, :url => '/system/:attachment/:id/:style/:basename.:extension',
                    :path => ':rails_root/public/system/:attachment/:id/:style/:basename.:extension',
                    :styles => {:medium => '250x250#', :thumb => '150x150#', :icon => '25x25#', :other => '640x563#'}
  validates_attachment :avatar, content_type: {content_type: ["image/jpg", "image/jpeg", "image/png"]}
  #validates_presence_of :avatar

  def email_required?
    false
  end

  def admin?
    self.role.title == "admin"
  end

  def user?
    self.role.title == "user"
  end

  def role?
    if admin?
      return "admin"
    elsif user?
      return "user"
    else
      return "no role"
    end
  end

  def iadoorns
    ids = adoorning_ids
    return User.find(ids)
  end

  def unread_mentions
    unless notification_setting.blank?
      if notification_setting.mentions == true
        mentions.where(:read_flag => false).order("created_at DESC")
      else
        []
      end
    else
      []
    end
  end

  def items_list(type)
    if type
      user_items.where(:is_active => true).order(:created_at => :desc)
    else
      user_items.where(:is_active => true, :private_flag => false).order(:created_at => :desc)
    end
  end

  def outfits_list(type)
    if type
      user_outfits.where(:is_active => true).order(:created_at => :desc)
    else
      user_outfits.where(:is_active => true, :private_flag => false).order(:created_at => :desc)
    end
  end

  def adoorning_ids
    UserAdoorner.where(:adoorner_id => id).map { |u| u.user_id }
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name # assuming the user model has a name
      user.last_name = auth.info.last_name # assuming the user model has a name
      user.user_name = auth.info.first_name # first_name is set as user_name
      user.avatar = process_uri(auth.info.image)
      user.skip_confirmation!
    end
  end

  def remember_me
    true
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.process_uri(uri)
    avatar_url = URI.parse(uri)
    avatar_url.scheme = 'https'
    avatar_url.to_s
  end

  def has_connection_with(provider)
    auth = self.authorizations.where(provider: provider).first
    if auth.present?
      auth.token.present?
    else
      false
    end
  end
end
