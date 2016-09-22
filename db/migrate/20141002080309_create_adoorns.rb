class CreateAdoorns < ActiveRecord::Migration
  def change
    create_table :adoorns do |t|
      t.references :user_blog
      t.references :user_item
      t.references :user_outfit
      t.references :user
      t.timestamps
    end
  end
end
