require_dependency "status_reportx/application_controller"

module StatusReportx
  class ReportsController < ApplicationController
    before_filter :require_employee
    before_filter :load_record
        
    def index
      @title = t('Reports')
      @reports = params[:status_reportx_reports][:model_ar_r]  #returned by check_access_right
      @reports = @reports.where('TRIM(status_reportx_reports.report_for) = ?', @report_for) if @report_for
      @reports = @reports.where('status_reportx_reports.resource_id = ?', @resource_id) if @resource_id 
      @reports = @reports.where('TRIM(status_reportx_reports.resource_string) = ?', @resource_string) if @resource_string
      @reports = @reports.where('status_reportx_reports.report_category_id = ?', params[:report_category_id]) if params[:report_category_id].present?
      @reports = @reports.page(params[:page]).per_page(@max_pagination) 
      @erb_code = find_config_const('report_index_view', 'status_reportx')
    end
  
    def new
      @title = t('New Report')
      @report = StatusReportx::Report.new()
      @erb_code = find_config_const('report_new_view', 'status_reportx')
    end
  
    def create
      @report = StatusReportx::Report.new(params[:report], :as => :role_new)
      @report.last_updated_by_id = session[:user_id]
      @report.reported_by_id = session[:user_id]
      if @report.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        @report_for = params[:report][:report_for].strip if params[:report][:report_for].present?
        @resource_id = params[:report][:resource_id] if params[:report][:resource_id].present?
        @resource_string = params[:report][:resource_string].strip if params[:report][:resource_string].present?
        @erb_code = find_config_const('report_new_view', 'status_reportx')
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Update Report')
      @report = StatusReportx::Report.find_by_id(params[:id]) if @report.blank?
      @erb_code = find_config_const('report_edit_view', 'status_reportx')
    end
  
    def update
      @report = StatusReportx::Report.find_by_id(params[:id]) 
      @report.last_updated_by_id = session[:user_id]
      if @report.update_attributes(params[:report], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        @erb_code = find_config_const('report_edit_view', 'status_reportx')
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
  
    def show
      @title = t('Report Info')
      @report = StatusReportx::Report.find_by_id(params[:id]) 
      @report_for = @report.report_for
      @erb_code = find_config_const('report_show_view', 'status_reportx')
    end
    
    protected
    
    def load_record
      @report_for = params[:report_for].strip if params[:report_for].present?
      @resource_id = params[:resource_id] if params[:resource_id].present?
      @resource_string = params[:resource_string].strip if params[:resource_string].present?
    end
  end
end
