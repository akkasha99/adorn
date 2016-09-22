class CreateFavBrands < ActiveRecord::Migration
  def change
    create_table :fav_brands do |t|
      t.references :brand
      t.references :user
      t.timestamps
    end
  end
end
