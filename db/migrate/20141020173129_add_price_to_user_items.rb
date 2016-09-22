class AddPriceToUserItems < ActiveRecord::Migration
  def change
    add_column :user_items, :price, :integer
  end
end
