class CreateBasicCategories < ActiveRecord::Migration
  def change
    create_table :basic_categories do |t|
      t.string :name
      t.timestamps
    end
  end
end
