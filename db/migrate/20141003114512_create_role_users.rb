class CreateRoleUsers < ActiveRecord::Migration
  def change
    create_table :role_users do |t|
      t.references :role
      t.references :user
      t.timestamps
    end
  end
end
