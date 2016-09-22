class AddsearchTypeToRecentSearches < ActiveRecord::Migration
  def change
    add_column :recent_searches, :search_type, :string
  end
end
