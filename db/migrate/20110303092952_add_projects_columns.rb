class AddProjectsColumns < ActiveRecord::Migration
  def self.up
    add_column :projects, :billable_hours, :float
    add_column :projects, :release_date, :date
    add_column :projects, :order_status, :string
  end

  def self.down
    remove_column :projects, :order_status
    remove_column :projects, :release_date
    remove_column :projects, :billable_hours
  end
end