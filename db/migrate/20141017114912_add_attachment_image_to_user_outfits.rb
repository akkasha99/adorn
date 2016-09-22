class AddAttachmentImageToUserOutfits < ActiveRecord::Migration
  def self.up
    change_table :user_outfits do |t|
      t.attachment :image
      t.boolean :is_active
    end
  end

  def self.down
    remove_attachment :user_outfits, :image
  end
end
