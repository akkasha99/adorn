class AddAttachmentImageToUserItems < ActiveRecord::Migration
  def self.up
    change_table :user_items do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :user_items, :image
  end
end
