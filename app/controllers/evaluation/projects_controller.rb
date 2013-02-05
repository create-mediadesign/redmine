# JSON representation of <tt>projects</tt>.
class Evaluation::ProjectsController < Evaluation::BaseController
  # Returns a JSON array of all <tt>projects</tt>, if no <tt>from</tt> parameter is given.
  # Returns a JSON array of <tt>projects</tt>, which <tt>updated_on</tt> attribute is greater or equal to the given <tt>from</tt> parameter.
  def index
    projects = params[:from].blank? ? ::Project.skip_dummy :
                                      ::Project.skip_dummy.updated_on_gte(params[:from])
    
    respond_to do |format|
      format.json { render :json => projects.map { |project| ::Evaluation::Json::Project.new(project) } }
    end
  end
end
