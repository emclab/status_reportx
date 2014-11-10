module StatusReportx
  class Report < ActiveRecord::Base
    attr_accessor :report_category_name, :reported_by_name, :last_updated_by_name, :subaction
    attr_accessible :issue_to_solve, :last_updated_by_id, :report_category_id, :report_date, :report_to_date, :report_from_date, :reported_by_id, 
                    :resource_id, :resource_string, :status_update, :thing_did, :thing_to_do, :wf_state, :report_for,
                    :as => :role_new
    attr_accessible :issue_to_solve, :last_updated_by_id, :report_category_id, :report_date, :report_to_date, :report_from_date, :reported_by_id, 
                    :status_update, :thing_did, :thing_to_do, :wf_state, :report_category_name, :report_category_name, :reported_by_name,
                    :last_updated_by_name,
                    :as => :role_update
    
    attr_accessor   :start_date_s, :end_date_s, :reported_by_id_s, :report_category_id_s, :report_for_s

    attr_accessible :start_date_s, :end_date_s, :reported_by_id_s, :report_category_id_s, :report_for_s, 
                    :as => :role_search_stats
                                    
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :reported_by, :class_name => 'Authentify::User'
    belongs_to :report_category, :class_name => StatusReportx.report_category_class.to_s 
    
    validates :resource_string, :report_date, :thing_did, :presence => true
    validates :resource_id, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
    validate :dynamic_validate 
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate', 'status_reportx')
      eval(wf) if wf.present?
    end        
  end
end
