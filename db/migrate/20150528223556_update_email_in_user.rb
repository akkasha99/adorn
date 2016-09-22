class UpdateEmailInUser < ActiveRecord::Migration
  def change
    change_column :users, :email, :string, :null => true, :limit => 190
  end
end
