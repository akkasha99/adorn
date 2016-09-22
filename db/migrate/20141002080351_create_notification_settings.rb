class CreateNotificationSettings < ActiveRecord::Migration
  def change
    create_table :notification_settings do |t|
      t.boolean :new_adoorns, :default => false
      t.boolean :mentions, :default => false
      t.boolean :item_adoorns, :default => false
      t.boolean :outfit_adoorns, :default => false
      t.boolean :special_offers, :default => false
      t.boolean :editor_recommendations, :default => false
      t.references :user
      t.timestamps
    end
  end
end
