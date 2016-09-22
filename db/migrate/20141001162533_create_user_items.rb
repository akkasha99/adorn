class CreateUserItems < ActiveRecord::Migration
  def change
    create_table :user_items do |t|
      t.string :title
      t.string :description
      t.string :pic_url
      t.boolean :private_flag, :default => false
      t.references :user
      t.timestamps
    end
  end
end
