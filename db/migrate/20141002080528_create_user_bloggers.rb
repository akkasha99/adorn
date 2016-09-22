class CreateUserBloggers < ActiveRecord::Migration
  def change
    create_table :user_bloggers do |t|
      t.integer :blogger_id
      t.references :user
      t.timestamps
    end
  end
end
