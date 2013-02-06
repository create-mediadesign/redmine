require File.expand_path('../../../test_helper', __FILE__)
require 'evaluation/projects_controller'

class Evaluation::ProjectsControllerTest < ActionController::TestCase
  fixtures :users, :projects, :tokens
  
  def setup
    Setting.rest_api_enabled = '1'
  end
  
  context "#index" do
    should "return 401 without an user session" do
      get :index, :format => :json
      assert_response 401
    end
    
    should "return success" do
      get :index, :format => :json, :key => key
      assert_response :success
    end
    
    should "return JSON" do
      get :index, :format => :json, :key => key
      assert_equal 'application/json', @response.content_type
    end
    
    context "with no from parameter" do
      should "return six project entries" do
        get :index, :format => :json, :key => key
        assert_equal 6, ActiveSupport::JSON.decode(@response.body).size
      end
    end
    
    context "with a from parameter of 2006-07-19" do
      should "return six project entries" do
        get :index, :from => '2006-07-19', :format => :json, :key => key
        assert_equal 6, ActiveSupport::JSON.decode(@response.body).size
      end
    end
    
    context "with a from parameter of 2006-07-20" do
      should "return zero project entries" do
        get :index, :from => '2006-07-20', :format => :json, :key => key
        assert ActiveSupport::JSON.decode(@response.body).empty?
      end
    end
  end
  
  def key
    'aahYSIaoYrsZUef86sTHrLISdznW6ApF36h5WSnm'
  end
end
