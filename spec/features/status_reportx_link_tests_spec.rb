require 'rails_helper'

RSpec.describe "LinkTests", type: :request do
  describe "GET /status_reportx_link_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link',
         'right-span#'         => '2', 
         'left-span#'         => '6', 
         'offset#'         => '2',
         'form-span#'         => '4'
        }
    before(:each) do
      config_entry = FactoryGirl.create(:engine_config, :engine_name => 'rails_app', :engine_version => nil, :argument_name => 'SESSION_TIMEOUT_MINUTES', :argument_value => 30)
      
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'status_reportx_reports', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "StatusReportx::Report.order('created_at DESC')")
        
      user_access = FactoryGirl.create(:user_access, :action => 'create_installation', :resource =>'status_reportx_reports', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'update_installation', :resource =>'status_reportx_reports', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show_installation', :resource =>'status_reportx_reports', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
      user_access = FactoryGirl.create(:user_access, :action => 'create_status_installation', :resource => 'commonx_logs', :role_definition_id => @role.id, :rank => 1,
      :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'destroy_installation', :resource =>'status_reportx_reports', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => @u.password
      click_button 'Login'
    end
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      task = FactoryGirl.create(:status_reportx_report, :last_updated_by_id => @u.id, :report_for => 'installation')
      visit status_reportx.reports_path(:report_for => task.report_for)
      expect(Authentify::SysLog.all.count).to eq(1)
      expect(Authentify::SysLog.all.first.resource).to eq('status_reportx/reports')
      expect(Authentify::SysLog.all.first.user_id).to eq(@u.id)
      #save_and_open_page
      expect(page).to have_content('Reports')
      click_link 'Edit'
      expect(page).to have_content('Update Report')
      #save_and_open_page
      fill_in 'report_report_date', :with => '2014-04-19'
      click_button 'Save'
      #with wrong data
      visit status_reportx.reports_path(:report_for => task.report_for)
      #save_and_open_page
      expect(page).to have_content('Reports')
      click_link 'Edit'
      fill_in 'report_report_date', :with => ''
      click_button 'Save'
      #save_and_open_page
      
      #delete
      visit status_reportx.reports_path(:report_for => task.report_for)
      #save_and_open_page
      click_link task.id.to_s
      expect(page).to have_content('Delete')
      
      visit status_reportx.reports_path(:report_for => task.report_for)
      #save_and_open_page
      click_link task.id.to_s
      #save_and_open_page
      expect(page).to have_content('Report Info')
      click_link 'New Log'
      #save_and_open_page
      expect(page).to have_content('Log')
      
      visit status_reportx.new_report_path(:report_for => task.report_for, :resource_id => 1, :resource_string => 'projectx/projects', :subaction => task.report_for)
      #save_and_open_page
      expect(page).to have_content('New Report')
      fill_in 'report_report_date', :with => Date.today
      fill_in 'report_thing_did', :with => 'a test spec'
      click_button 'Save'
      save_and_open_page
      #with wrong data
      visit status_reportx.new_report_path(:report_for => task.report_for, :resource_id => 1, :resource_string => 'projectx/projects', :subaction => task.report_for)
      save_and_open_page
      expect(page).to have_content('New Report')
      fill_in 'report_report_date', :with => Date.today
      fill_in 'report_thing_did', :with => ''
      click_button 'Save'
      save_and_open_page
    end
  end
end
