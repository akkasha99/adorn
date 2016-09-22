class Brand < ActiveRecord::Base

  has_attached_file :logo, :url => '/system/:attachment/:id/:style/:basename.:extension',
                    :path => ':rails_root/public/system/:attachment/:id/:style/:basename.:extension',
                    :styles => {:medium => '250x250#', :other => '640x530', :thumb => '150x150#'}
  validates_attachment :logo, content_type: {content_type: ["image/jpg", "image/jpeg", "image/png"]}
  validates_presence_of :logo
end
