class AddIsActiveToUserItem < ActiveRecord::Migration
  def change
    add_column :user_items, :is_active, :boolean , :default => true
    add_column :user_blogs, :is_active, :boolean , :default => true
  end
end
