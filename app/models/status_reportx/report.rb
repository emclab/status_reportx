module StatusReportx
  class Report < ActiveRecord::Base
    
    default_scope {where(fort_token: Thread.current[:fort_token])}
    
    attr_accessor :report_category_name, :reported_by_name, :last_updated_by_name, :subaction
                             
    belongs_to :last_updated_by, :class_name => 'Authentify::User'
    belongs_to :reported_by, :class_name => 'Authentify::User'
    belongs_to :report_category, :class_name => StatusReportx.report_category_class.to_s 
    
    validates :resource_string, :report_date, :thing_did, :report_for, :presence => true
    validates :resource_id, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
    validate :dynamic_validate 
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate', self.fort_token, 'status_reportx')
      eval(wf) if wf.present?
    end        
  end
end
