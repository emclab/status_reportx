module StatusReportx
  class ApplicationController < ::ApplicationController
    include Authentify::SessionsHelper
    include Authentify::AuthentifyUtility
    include Authentify::UsersHelper
    include Authentify::UserPrivilegeHelper
    include Commonx::CommonxHelper
    include Searchx::SearchHelper
    
    before_action :require_signin
    before_action :max_pagination 
    before_action :check_access_right 
    before_action :load_session_variable, :only => [:new, :edit]  #for parent_record_id & parent_resource in check_access_right
    after_action :delete_session_variable, :only => [:create, :update]   #for parent_record_id & parent_resource in check_access_right
    before_action :page_params, :only => :index
    
    helper_method :return_resources_by_access_right
    
    protected
  
    def max_pagination
      @max_pagination = find_config_const('pagination', session[:fort_token])
    end
    
    def return_resources_by_access_right(resource_string)  #purchase_orderx_orders
      access_rights, model_ar_r, has_record_access = access_right_finder('index', resource_string, session[:user_role_ids], session[:fort_token])
      return [] if access_rights.blank?
      return model_ar_r #instance_eval(access_rights.sql_code) #.present?
    end
  end
end
