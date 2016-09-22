class RenameAdoornToAdorn < ActiveRecord::Migration
  def change
    rename_table :adoorns, :adorns
  end
end
