class CreateUserAdoorners < ActiveRecord::Migration
  def change
    create_table :user_adoorners do |t|
      t.integer :adoorner_id
      t.references :user
      t.timestamps
    end
  end
end
