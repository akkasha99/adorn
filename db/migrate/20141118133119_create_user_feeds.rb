class CreateUserFeeds < ActiveRecord::Migration
  def change
    create_table :user_feeds do |t|
      t.text :url
      t.references :user, index: true

      t.timestamps
    end
  end
end
