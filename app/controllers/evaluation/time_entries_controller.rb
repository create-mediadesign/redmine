# JSON representation of <tt>time_entries</tt>.
class Evaluation::TimeEntriesController < Evaluation::BaseController
  # Returns a JSON array of all <tt>time entries</tt>, if no <tt>from</tt> parameter is given.
  # Returns a JSON array of <tt>time entries</tt>, which <tt>updated_on</tt> attribute is greater or equal to the given <tt>from</tt> parameter.
  def index
    time_entries = params[:from].blank? ? ::TimeEntry.for_projects(Project.skip_dummy) :
                                          ::TimeEntry.for_projects(Project.skip_dummy).updated_on_gte(params[:from])
    
    respond_to do |format|
      format.json { render :json => time_entries.map { |time_entry| Evaluation::Json::TimeEntry.new(time_entry) } }
    end
  end
end
