class RenameBasicCategoryToSubCategory < ActiveRecord::Migration
  def change
    rename_column :basic_items, :basic_category_id, :basic_subcategory_id
  end
end
