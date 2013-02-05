require File.expand_path('../../../../test_helper', __FILE__)

class Evaluation::Json::ProjectTest < ActiveSupport::TestCase
  fixtures :projects, :roles
  
  context('#as_json') do
    setup do
      @project = Evaluation::Json::Project.new(projects(:projects_001))
    end
    
    should('add member_user_ids') do
      assert_equal([2, 3], @project.as_json[:member_user_ids])
    end
    
    should('add responsible_user_ids') do
      roles(:roles_001).update_attribute(:blamable, true)
      assert_equal([2], @project.as_json[:responsible_user_ids])
    end
    
    should('add custom values') do
      assert_equal('Stable', @project.as_json['Development status'])
    end
  end
end
