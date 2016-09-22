class AddContentTypeToMentions < ActiveRecord::Migration
  def change
    add_column :mentions, :content_id, :integer
    add_column :mentions, :content_type, :string
  end
end
