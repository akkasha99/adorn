class AddBasicItemIdToOutfitItem < ActiveRecord::Migration
  def change
    add_column :outfit_items, :basic_item_id, :integer
  end
end
