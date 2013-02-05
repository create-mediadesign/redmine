# Redmine - project management software
# Copyright (C) 2006-2012  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require File.expand_path('../../test_helper', __FILE__)

class TimeEntryTest < ActiveSupport::TestCase
  fixtures :issues, :projects, :users, :time_entries,
           :members, :roles, :member_roles,
           :trackers, :issue_statuses,
           :projects_trackers,
           :journals, :journal_details,
           :issue_categories, :enumerations,
           :groups_users,
           :enabled_modules,
           :workflows, :departments

  def test_hours_format
    assertions = { "2"      => 2.0,
                   "21.1"   => 21.1,
                   "2,1"    => 2.1,
                   "1,5h"   => 1.5,
                   "7:12"   => 7.2,
                   "10h"    => 10.0,
                   "10 h"   => 10.0,
                   "45m"    => 0.75,
                   "45 m"   => 0.75,
                   "3h15"   => 3.25,
                   "3h 15"  => 3.25,
                   "3 h 15"   => 3.25,
                   "3 h 15m"  => 3.25,
                   "3 h 15 m" => 3.25,
                   "3 hours"  => 3.0,
                   "12min"    => 0.2,
                   "12 Min"    => 0.2,
                  }

    assertions.each do |k, v|
      t = TimeEntry.new(:hours => k)
      assert_equal v, t.hours, "Converting #{k} failed:"
    end
  end

  def test_hours_should_default_to_nil
    assert_nil TimeEntry.new.hours
  end

  def test_spent_on_with_blank
    c = TimeEntry.new
    c.spent_on = ''
    assert_nil c.spent_on
  end

  def test_spent_on_with_nil
    c = TimeEntry.new
    c.spent_on = nil
    assert_nil c.spent_on
  end

  def test_spent_on_with_string
    c = TimeEntry.new
    c.spent_on = "2011-01-14"
    assert_equal Date.parse("2011-01-14"), c.spent_on
  end

  def test_spent_on_with_invalid_string
    c = TimeEntry.new
    c.spent_on = "foo"
    assert_nil c.spent_on
  end

  def test_spent_on_with_date
    c = TimeEntry.new
    c.spent_on = Date.today
    assert_equal Date.today, c.spent_on
  end

  def test_spent_on_with_time
    c = TimeEntry.new
    c.spent_on = Time.now
    assert_equal Date.today, c.spent_on
  end
  
  def test_update_user_last_department_after_create
    @user = users(:users_001)
    @department = departments(:departments_003)
    @public_project = Project.generate!(:is_public => true)
    @issue = Issue.generate_for_project!(@public_project)
    @time_entry = TimeEntry.create!(:spent_on => '2010-01-01',
                                    :hours    => 2,
                                    :issue => @issue,
                                    :project => @public_project,
                                    :user => @user,
                                    :department => @department)
    assert_equal @department, @user.last_department
  end
  
  def test_setting_of_department_from_user
    @department = departments(:departments_003)
    @user = User.current = users(:users_001)
    @user.last_department = @department
    @time_entry = TimeEntry.new
    assert_equal @user.last_department, @time_entry.department
  end
  
  context "#updated_on_gte" do
    should "return all time entries from 2007-03-23" do
      assert_equal 5, TimeEntry.updated_on_gte('2007-03-23').size
    end
    
    should "return all time entries from 2007-04-21" do
      assert_equal 3, TimeEntry.updated_on_gte('2007-04-21').size
    end
  end
  
  context "#for_user" do
    should "return all time entries for a given user" do
      assert_equal [time_entries(:time_entries_002), time_entries(:time_entries_003), time_entries(:time_entries_004), time_entries(:time_entries_005)], TimeEntry.for_user(users(:users_001))
    end
  end
  
  context "#for_today" do
    should "return all time entries for today" do
      user = users(:users_001)
      department = departments(:departments_003)
      public_project = Project.generate!(:is_public => true)
      issue = Issue.generate_for_project!(public_project)
      time_entry = TimeEntry.create!(:spent_on => Date.today,
                                     :hours    => 2,
                                     :issue => issue,
                                     :project => public_project,
                                     :user => user,
                                     :department => department)
                                       
      assert_equal [time_entry], TimeEntry.for_today
    end
  end

  def test_validate_time_entry
    anon     = User.anonymous
    project  = Project.find(1)
    issue    = Issue.new(:project_id => 1, :tracker_id => 1, :author_id => anon.id, :status_id => 1,
                         :priority => IssuePriority.all.first, :subject => 'test_create',
                         :description => 'IssueTest#test_create', :estimated_hours => '1:30')
    assert issue.save
    activity = TimeEntryActivity.find_by_name('Design')
    te = TimeEntry.create(:spent_on => '2010-01-01',
                          :hours    => 100000,
                          :issue    => issue,
                          :project  => project,
                          :user     => anon,
                          :activity => activity)
    assert_equal 1, te.errors.count
  end

  def test_set_project_if_nil
    anon     = User.anonymous
    project  = Project.find(1)
    issue    = Issue.new(:project_id => 1, :tracker_id => 1, :author_id => anon.id, :status_id => 1,
                         :priority => IssuePriority.all.first, :subject => 'test_create',
                         :description => 'IssueTest#test_create', :estimated_hours => '1:30')
    assert issue.save
    activity = TimeEntryActivity.find_by_name('Design')
    te = TimeEntry.create(:spent_on => '2010-01-01',
                          :hours    => 10,
                          :issue    => issue,
                          :user     => anon,
                          :activity => activity)
    assert_equal project.id, te.project.id
  end
end
