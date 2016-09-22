class AddAttachmentImageToBasicItems < ActiveRecord::Migration
  def self.up
    change_table :basic_items do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :basic_items, :image
  end
end
