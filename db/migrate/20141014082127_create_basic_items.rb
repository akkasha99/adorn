class CreateBasicItems < ActiveRecord::Migration
  def change
    create_table :basic_items do |t|
      t.string :title
      t.string :description
      t.string :price
      t.references :basic_category
      t.timestamps
    end
  end
end
