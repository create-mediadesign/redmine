class AddProjectsColumnType < ActiveRecord::Migration
  def self.up
    add_column :projects, :typ, :string
    
    for project in Project.all
      project.update_attribute(:typ, 'Not defined')
    end
    
    change_column :projects, :typ, :string, :null => false
  end

  def self.down
    remove_column :projects, :typ
  end
end