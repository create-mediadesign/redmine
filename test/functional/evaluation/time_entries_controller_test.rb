require File.expand_path('../../../test_helper', __FILE__)
require 'evaluation/time_entries_controller'

class Evaluation::TimeEntriesControllerTest < ActionController::TestCase
  fixtures :users, :time_entries
  
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
      should "return four time entries" do
        get :index, :format => :json, :key => key
        assert_equal 5, ActiveSupport::JSON.decode(@response.body).size
      end
    end
    
    context "with a from parameter of 2007-04-21" do
      should "return two time entries" do
        get :index, :from => '2007-04-21', :format => :json, :key => key
        assert_equal 3, ActiveSupport::JSON.decode(@response.body).size
      end
    end
  end
  
  def key
    'aahYSIaoYrsZUef86sTHrLISdznW6ApF36h5WSnm'
  end
end
