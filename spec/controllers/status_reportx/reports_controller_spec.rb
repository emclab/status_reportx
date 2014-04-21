require 'spec_helper'

module StatusReportx
  describe ReportsController do
    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
           
    end
    
    before(:each) do
      
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
    end
    
    render_views
    
    describe "GET 'index'" do
      it "returns reports" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'status_reportx_reports', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "StatusReportx::Report.order('id DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:status_reportx_report,  :resource_id => 1, :resource_string => 'supplied_partx/parts')
        task1 = FactoryGirl.create(:status_reportx_report,  :resource_id => 2, :resource_string => 'sourced_partx/parts' )
        get 'index', {:use_route => :status_reportx}
        assigns[:reports].should =~ [task, task1]
      end
      
      it "should return reports for report_for" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'status_reportx_reports', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "StatusReportx::Report.order('id DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:status_reportx_report,  :report_for => 'installation')
        task1 = FactoryGirl.create(:status_reportx_report, :report_for => 'not_installatin')
        get 'index', {:use_route => :status_reportx, :report_for => 'installation'}
        assigns[:reports].should =~ [task]
      end
      
      it "should return reports for the resource_strng & subaction" do
        user_access = FactoryGirl.create(:user_access, :action => 'index_supplied_part', :resource =>'status_reportx_reports', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "StatusReportx::Report.order('id DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:status_reportx_report,  :resource_id => 1, :resource_string => 'supplied_partx/parts')
        task1 = FactoryGirl.create(:status_reportx_report,  :resource_id => 1, :resource_string => 'sourced_partx/parts' )
        get 'index', {:use_route => :status_reportx, :subaction => 'supplied_part'}
        assigns[:reports].should =~ [task, task1]
      end
      
      it "should only return supplied part reports" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'status_reportx_reports', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "StatusReportx::Report.order('id DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:status_reportx_report,  :resource_id => 1, :resource_string => 'sourced_partx/parts')
        task1 = FactoryGirl.create(:status_reportx_report, :resource_id => 1, :resource_string => 'supplied_partx/parts')
        get 'index', {:use_route => :status_reportx, :resource_string => 'supplied_partx/parts'}
        assigns[:reports].should =~ [task1]
      end
      
      it "should only return reports which belongs to :report_for" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'status_reportx_reports', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "StatusReportx::Report.order('id DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:status_reportx_report, :resource_id => 1, :resource_string => 'supplied_partx/parts', :report_for => 'prod')
        task1 = FactoryGirl.create(:status_reportx_report, :resource_id => 1, :resource_string => 'sourced_partx/parts', :report_for => 'inst')
        get 'index', {:use_route => :status_reportx,  :report_for => 'prod'}
        assigns[:reports].should =~ [task]
      end
      
      it "should only return reportts of sourced part and id" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'status_reportx_reports', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "StatusReportx::Report.order('id DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:status_reportx_report,  :resource_id => 1, :resource_string => 'sourced_partx/parts')
        task1 = FactoryGirl.create(:status_reportx_report, :resource_id => 1, :resource_string => 'supplied_partx/parts')
        get 'index', {:use_route => :status_reportx, :resource_id => 1, :resource_string => 'supplied_partx/parts'}
        assigns[:reports].should =~ [task1]
      end
            
    end
  
    describe "GET 'new'" do
      it "returns bring up new page" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'status_reportx_reports', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new', {:use_route => :status_reportx,  :resource_id => 1, :resource_string => 'supplied_partx/parts'}
        response.should be_success
      end
      
      it "should bring up new page for subaction" do
        user_access = FactoryGirl.create(:user_access, :action => 'create_supplied_partx', :resource =>'status_reportx_reports', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new', {:use_route => :status_reportx,  :resource_id => 1, :resource_string => 'supplied_partx/parts', :subaction => 'supplied_partx'}
        response.should be_success
      end
      
    end
  
    describe "GET 'create'" do
      it "should create and redirect after successful creation" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'status_reportx_reports', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.attributes_for(:status_reportx_report, :resource_id => 1, :resource_string => 'supplied_partx/parts' )  
        get 'create', {:use_route => :status_reportx, :report => task, :resource_id => 1, :resource_string => 'supplied_partx/parts'}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render 'new' if data error" do        
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'status_reportx_reports', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.attributes_for(:status_reportx_report, :resource_id => 1, :resource_string => 'supplied_partx/parts', :report_date => nil)
        get 'create', {:use_route => :status_reportx, :report => task, :resource_id => 1, :resource_string => 'supplied_partx/parts', :report_for => 'install'}
        response.should render_template('new')
      end
      
      it "should create for subaction and redirect after successful creation" do
        user_access = FactoryGirl.create(:user_access, :action => 'create_supplied_partx', :resource =>'status_reportx_reports', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.attributes_for(:status_reportx_report, :resource_id => 1, :resource_string => 'supplied_partx/parts' )  
        get 'create', {:use_route => :status_reportx, :report => task, :resource_id => 1, :resource_string => 'supplied_partx/parts', :subaction => 'supplied_partx'}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
    end
  
    describe "GET 'edit'" do
      it "returns edit page" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'status_reportx_reports', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:status_reportx_report, :resource_id => 1, :resource_string => 'supplied_partx/parts')
        get 'edit', {:use_route => :status_reportx, :id => task.id}
        response.should be_success
      end
      
    end
  
    describe "GET 'update'" do
      it "should return success and redirect" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'status_reportx_reports', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:status_reportx_report, :resource_id => 1, :resource_string => 'supplied_partx/parts')
        get 'update', {:use_route => :status_reportx, :id => task.id, :report => {:report_date => '2013-01-01'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render edit with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'status_reportx_reports', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:status_reportx_report, :resource_id => 1, :resource_string => 'supplied_partx/parts')
        get 'update', {:use_route => :status_reportx, :id => task.id, :report => {:report_date => ''}}
        response.should render_template('edit')
      end
    end
  
    describe "GET 'show'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'status_reportx_reports', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.reported_by_id == session[:user_id]")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        task = FactoryGirl.create(:status_reportx_report, :resource_id => 1, :resource_string => 'supplied_partx/parts')
        get 'show', {:use_route => :status_reportx, :id => task.id}
        response.should be_success
      end
    end
  end
end
