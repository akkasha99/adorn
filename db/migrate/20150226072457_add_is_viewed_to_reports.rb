class AddIsViewedToReports < ActiveRecord::Migration
  def change
    add_column :reports, :is_viewed, :boolean
  end
end
