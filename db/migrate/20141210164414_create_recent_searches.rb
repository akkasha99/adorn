class CreateRecentSearches < ActiveRecord::Migration
  def change
    create_table :recent_searches do |t|
      t.string :search
      t.references :user
      t.timestamps
    end
  end
end
