class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :text
      t.references :user_blog
      t.references :user_item
      t.references :user_outfit
      t.references :user
      t.timestamps
    end
  end
end
