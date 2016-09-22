class AddColorToBasicItems < ActiveRecord::Migration
  def change
    add_column :basic_items, :color, :string
  end
end
