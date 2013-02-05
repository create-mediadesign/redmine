class CreateDepartments < ActiveRecord::Migration
  def self.up
    create_table :departments do |t|
      t.column :name, :string, :null => false
      t.column :parent_id, :integer
    end
    
    ['Geschäftsführung', 'Finanzbuchhaltung', 'Vertrieb', 'Konzeption', 'Kreation', 'Programmierung'].each do |name|
      Department.create! :name => name
    end
    
    add_column :time_entries, :department_id, :integer
    
    not_assigned = Department.find_by_name('Nicht zugewiesen')
    for time_entry in TimeEntry.all
      time_entry.update_attribute :department_id, not_assigned.id
    end
    
    change_column :time_entries, :department_id, :integer, :null => false
    add_column :users, :last_department_id, :integer
  end

  def self.down
    remove_column :users, :last_department_id
    remove_column :time_entries, :department_id
    drop_table :departments
  end
end