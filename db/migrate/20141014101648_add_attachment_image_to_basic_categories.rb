class AddAttachmentImageToBasicCategories < ActiveRecord::Migration
  def self.up
    change_table :basic_categories do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :basic_categories, :image
  end
end
