class AddHideAsUserToUser < ActiveRecord::Migration
  def change
    add_column :users, :hide_as_user, :boolean, :default => false
  end
end
