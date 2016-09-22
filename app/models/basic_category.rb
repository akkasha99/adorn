class BasicCategory < ActiveRecord::Base

  has_many :basic_subcategories , :dependent => :destroy

  has_attached_file :image, :url => '/system/:attachment/:id/:style/:basename.:extension',
                    :path => ':rails_root/public/system/:attachment/:id/:style/:basename.:extension',
                    :styles => {:medium => '250x250', :other => '640x530', :canvas => '100x100', :thumb => '150x150', :icon => '50x50'}
  validates_attachment :image, content_type: {content_type: ["image/jpg", "image/jpeg", "image/png"]}
  validates_presence_of :image
end
