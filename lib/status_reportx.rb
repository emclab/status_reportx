require "status_reportx/engine"

module StatusReportx
  mattr_accessor :report_category_class
  
  def self.report_category_class
    @@report_category_class.constantize
  end
end
