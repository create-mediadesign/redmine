class AddRolesColumn < ActiveRecord::Migration
  def self.up
    add_column :roles, :blamable, :boolean, :default => false
  end

  def self.down
    remove_column :roles, :blamable
  end
end