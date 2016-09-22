class RenameMentionsColumn < ActiveRecord::Migration
  def change
    rename_column :mentions, :type, :mention_type
  end
end
