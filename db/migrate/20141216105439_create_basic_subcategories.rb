class CreateBasicSubcategories < ActiveRecord::Migration
  def change
    create_table :basic_subcategories do |t|
      t.string :name
      t.attachment :image
      t.references :basic_category
      t.timestamps
    end
  end
end
