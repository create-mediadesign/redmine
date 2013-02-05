# JSON representation of <tt>users</tt>.
class Evaluation::UsersController < Evaluation::BaseController
  # Returns a JSON array of all <tt>users</tt>, if no <tt>from</tt> parameter is given.
  # Returns a JSON array of <tt>users</tt>, which <tt>updated_on</tt> attribute is greater or equal to the given <tt>from</tt> parameter.
  def index
    users = params[:from].blank? ? User.all : User.updated_on_gte(params[:from])
    
    respond_to do |format|
      format.json { render :json => users }
    end
  end
end
