class BasicSubcategory < ActiveRecord::Base
  belongs_to :basic_category
  has_many :basic_items, :dependent => :destroy

  has_attached_file :image, :url => '/system/:attachment/:id/:style/:basename.:extension',
                    :path => ':rails_root/public/system/:attachment/:id/:style/:basename.:extension',
                    :styles => {:medium => '250x250', :canvas => '100x100', :other => '640x530', :thumb => '150x150', :icon => '50x50'}
  validates_attachment :image, content_type: {content_type: ["image/jpg", "image/jpeg", "image/png"]}
  validates_presence_of :image
end
