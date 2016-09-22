class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :name
      t.string :pic_url
      t.timestamps
    end
  end
end
