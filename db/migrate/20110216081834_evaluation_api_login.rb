class EvaluationApiLogin < ActiveRecord::Migration
  def self.up
    Setting.create! :name => 'rest_api_enabled', :value => 1    
    user = User.new :firstname => "eval",
                    :lastname => "eval",
                    :mail => "nomail@create.at",
                    :mail_notification => false,
                    :language => "en",
                    :status => 1
    user.login = "eval"
    user.hashed_password = "d033e22ae348aeb5660fc2140aec35850c4da997"
    user.admin = true
    user.save!
    
    # Creates API token.
    user.api_key
  end

  def self.down
    Setting.find_by_name('rest_api_enabled').try(:destroy)
    User.find_by_login('eval').try(:destroy)
  end
end
