class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :comment
      t.integer :by_user
      t.references :user_blog
      t.references :user_item
      t.references :user_outfit
      t.references :user
      t.timestamps
    end
  end
end
