# Project JSON representation.
class Evaluation::Json::Project
  def initialize(project)
    @project = project
    @custom_fields = {}
    
    project.custom_values.each do |value|
      @custom_fields[value.custom_field.name] = value.value
    end
  end
  
  # Returns a hash used by the <tt>to_json</tt> method to build a JSON string.
  def as_json(options={})
    users = @project.users
    responsible_users = users.select { |user| user.roles_for_project(@project).any? { |role| role.blamable? } }
    member_users = users - responsible_users
    
    @project.as_json.merge(:member_user_ids => member_users.map(&:id), :responsible_user_ids => responsible_users.map(&:id)).
                     merge(@custom_fields)
  end
end
