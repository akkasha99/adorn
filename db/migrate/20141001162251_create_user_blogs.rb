class CreateUserBlogs < ActiveRecord::Migration
  def change
    create_table :user_blogs do |t|
      t.string :text
      t.string :pic_url
      t.boolean :private_flag, :default => false
      t.references :user
      t.timestamps
    end
  end
end
