# Evaluation version of a TimeEntry object.
class Evaluation::Json::TimeEntry
  def initialize(time_entry)
    @time_entry = time_entry
  end
  
  # @param [Hash] options see Rails API
  # @return [Hash] JSON representation.
  def as_json(options={})
    issue = @time_entry.issue
    
    if issue
      @time_entry.as_json.merge(:tracker => issue.tracker.name, :issue => issue.subject)
    else
      @time_entry.as_json.merge(:tracker => nil, :issue => nil)
    end
  end
end
