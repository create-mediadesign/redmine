require File.expand_path('../../test_helper', __FILE__)

class DepartmentTest < ActiveSupport::TestCase
  fixtures :departments
  
  def test_attribute_accessible
    department = Department.new :id => 1, :name => 'Sales', :parent_id => 1
    assert_nil department.id
    assert_nil department.parent_id
    assert_equal 'Sales', department.name
  end
  
  def test_presence_of_name
    I18n.locale = :en
    department = Department.new
    assert !department.valid?
    assert_equal 1, department.errors.size
    assert_equal ["can't be blank"], department.errors.get(:name)
  end
  
  def test_uniqueness_of_name_on_same_partent
    I18n.locale = :en
    department1 = Department.create! :name => 'a'
    new_department = Department.new :name => 'a'
    assert !new_department.valid?
    assert_equal 1, new_department.errors.size
    assert_equal ['has already been taken'], new_department.errors.get(:name)
  end
  
  def test_uniqueness_of_name_on_different_parent
    department1 = Department.create! :name => 'a'
    new_department = Department.new :name => 'a'
    new_department.parent_id = 1
    assert new_department.valid?
    assert new_department.errors.empty?
  end
  
  def test_order_by_name
    departments = Department.all
    assert_equal 'Marketing', departments.first.name
    assert_equal 'Sales', departments[1].name
    assert_equal 'Sales1', departments.last.name
  end
  
  def test_scope_roots
    departments = Department.roots
    assert_equal 2, departments.size
  end
  
  def test_to_s
    assert_equal 'Sales', Department.new(:name => 'Sales').to_s
  end
end
