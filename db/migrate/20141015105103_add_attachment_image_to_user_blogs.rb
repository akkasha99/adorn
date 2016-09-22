class AddAttachmentImageToUserBlogs < ActiveRecord::Migration
  def self.up
    change_table :user_blogs do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :user_blogs, :image
  end
end
