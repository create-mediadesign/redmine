# Represents a department of a company i.e. Management, Sales, ...
#
# Name of table: <tt>departments</tt>.
#
# +-----------+--------------+------+-----+---------+----------------+
# | Field     | Type         | Null | Key | Default | Extra          |
# +-----------+--------------+------+-----+---------+----------------+
# | id        | int(11)      | NO   | PRI | NULL    | auto_increment |
# | name      | varchar(255) | NO   |     | NULL    |                |
# | parent_id | int(11)      | YES  |     | NULL    |                |
# +-----------+--------------+------+-----+---------+----------------+
#
class Department < ActiveRecord::Base
  # Attributes, which can be modified via a form.
  attr_accessible :name
  
  DEFAULT_ID = 6
  
  # Plugins.
  acts_as_tree
  
  # Validations.
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :parent_id
  
  # Scopes.
  default_scope(:order => :name)
  scope(:roots, :conditions => { :parent_id => nil })
  
  # Returns the name as the string representation.
  def to_s
    name
  end
end
