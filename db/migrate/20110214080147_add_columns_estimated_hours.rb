class AddColumnsEstimatedHours < ActiveRecord::Migration
  def self.up
    add_column :projects, :estimated_hours, :float
    add_column :versions, :projected_hours, :float
  end

  def self.down
    remove_column :versions, :projected_hours
    remove_column :projects, :estimated_hours
  end
end