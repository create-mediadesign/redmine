require File.expand_path('../../../../test_helper', __FILE__)

class Evaluation::Json::TimeEntryTest < ActiveSupport::TestCase
  fixtures :time_entries
  
  context('#as_json') do
    context('without a corresponding issue') do
      setup do
        @time_entry = Evaluation::Json::TimeEntry.new(time_entries(:time_entries_004))
      end
      
      should('add a tracker attribute with a nil value to the JSON representation of the original time entry object') do
        assert_equal(nil, @time_entry.as_json[:tracker])
      end
      
      should('add an issue attribute with a nil value to the JSON representation of the original time entry object') do
        assert_equal(nil, @time_entry.as_json[:issue])
      end
    end
    
    context('with a corresponding issue') do
      setup do
        @time_entry = Evaluation::Json::TimeEntry.new(time_entries(:time_entries_001))
      end
      
      should("add a tracker attribute with it's name to the JSON representation of the original time entry object") do
        assert_equal(time_entries(:time_entries_001).issue.tracker.name, @time_entry.as_json[:tracker])
      end
      
      should("add an issue attribute with it's name to the JSON representation of the original time entry object") do
        assert_equal(time_entries(:time_entries_001).issue.subject, @time_entry.as_json[:issue])
      end
    end
    
    should('work with #to_json') do
      @time_entry = Evaluation::Json::TimeEntry.new(time_entries(:time_entries_001))
      assert_nothing_raised(ArgumentError) { @time_entry.to_json }
    end
  end
end
