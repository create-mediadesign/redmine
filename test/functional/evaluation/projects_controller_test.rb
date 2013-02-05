require File.expand_path('../../../test_helper', __FILE__)
require 'evaluation/projects_controller'

class Evaluation::ProjectsControllerTest < ActionController::TestCase
  fixtures :users, :projects
  
  def setup
    @controller = Evaluation::ProjectsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user_id] = 1
  end
  
  context "#index" do
    should "return 401 without an user session" do
      @request.session[:user_id] = nil
      get :index, :format => :json
      assert_response 401
    end
    
    should "return success" do
      get :index, :format => :json
      assert_response :success
    end
    
    should "return JSON" do
      get :index, :format => :json
      assert_equal 'application/json', @response.content_type
    end
    
    context "with no from parameter" do
      should "return six project entries" do
        get :index, :format => :json
        assert_equal 6, ActiveSupport::JSON.decode(@response.body).size
      end
    end
    
    context "with a from parameter of 2006-07-19" do
      should "return six project entries" do
        get :index, :from => '2006-07-19', :format => :json
        assert_equal 6, ActiveSupport::JSON.decode(@response.body).size
      end
    end
    
    context "with a from parameter of 2006-07-20" do
      should "return zero project entries" do
        get :index, :from => '2006-07-20', :format => :json
        assert ActiveSupport::JSON.decode(@response.body).empty?
      end
    end
  end
end
