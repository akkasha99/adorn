require "open-uri"

class UserItem < ActiveRecord::Base
  belongs_to :user
  #belongs_to :user_outfit
  has_many :outfit_items

  has_many :user_outfit, through: :outfit_items

  has_many :adorns, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  has_attached_file :image, :url => '/system/:attachment/:id/:style/:basename.:extension',
                    :path => ':rails_root/public/system/:attachment/:id/:style/:basename.:extension',
                    :styles => {:medium => '250x250#', :thumb => '150x150#', :icon => '50x50#', :small => '100x100#', :other => '640x530'} ,
                    :convert_options => {:medium => '-quality 100', :medium => "-gravity center -background transparent -extent 250x250" , :other => "-quality 100" }
  validates_attachment :image, content_type: {content_type: ["image/jpg", "image/jpeg", "image/png"]}
  #validates_presence_of :image

  def item_adoorners
    adorns.map { |a| a.user_id }
  end

  def is_adoorned(id)
    if adorns.where(:user_id => id).first.present?
      return true
    else
      return false
    end
  end

  def picture_from_url(url)
    begin
      io = open(URI.parse(url))
      self.image = io
    rescue Exception => e
      puts "sssssseeeeeeeeeeeeeeeee", e.message
    end
  end

end
