class CreateUserOutfits < ActiveRecord::Migration
  def change
    create_table :user_outfits do |t|
      t.string :title
      t.string :description
      t.string :pic_url
      t.boolean :private_flag, :default => false
      t.references :user
      t.timestamps
    end
  end
end
