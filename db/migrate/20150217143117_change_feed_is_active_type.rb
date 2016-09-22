class ChangeFeedIsActiveType < ActiveRecord::Migration
  def up
    # change_column :user_feeds, :is_active, :integer, :default => 2    ##for mysql
    change_column :user_feeds, :is_active, 'integer USING CAST(is_active AS integer)', :default => 2
    # change_column :user_feeds, :is_active, :default => 2
  end

  def down
    change_column :user_feeds, :is_active, :boolean
  end
end
