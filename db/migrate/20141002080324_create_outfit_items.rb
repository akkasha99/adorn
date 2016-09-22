class CreateOutfitItems < ActiveRecord::Migration
  def change
    create_table :outfit_items do |t|
      t.references :user_item
      t.references :user_outfit
      t.timestamps
    end
  end
end
