class UserBlog < ActiveRecord::Base
  belongs_to :user
  has_many :adorns
  has_many :comments

  has_attached_file :image, :url => '/system/:attachment/:id/:style/:basename.:extension',
                    :path => ':rails_root/public/system/:attachment/:id/:style/:basename.:extension',
                    :styles => {:medium => '250x250#', :thumb => '150x150#', :icon => '50x50#', :other => '640x530'}
  validates_attachment :image, content_type: {content_type: ["image/jpg", "image/jpeg", "image/png"]}
  #validates_presence_of :image

  def blog_adoorners
    adorns.map { |a| a.user_id }
  end

  def is_adoorned(id)
    if adorns.where(:user_id => id).first.present?
      return true
    else
      return false
    end
  end
end
