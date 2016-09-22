class AddIsActiveToUser < ActiveRecord::Migration
  def change
    add_column :users, :isactive, :boolean , :default => true
  end
end
