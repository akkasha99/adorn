class ChangeItyemPriceDataType < ActiveRecord::Migration
  def change
    change_column :user_items, :price, :float
  end
end
