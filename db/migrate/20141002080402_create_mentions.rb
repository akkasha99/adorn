class CreateMentions < ActiveRecord::Migration
  def change
    create_table :mentions do |t|
      t.string :type
      t.integer :by_user
      t.boolean :read_flag, :default => false
      t.references :user
      t.references :user_blog
      t.references :user_item
      t.references :user_outfit
      t.timestamps
    end
  end
end
