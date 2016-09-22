class AddBuyLinkInUserItem < ActiveRecord::Migration
  def change
    add_column :user_items, :buy_link, :string
  end
end
