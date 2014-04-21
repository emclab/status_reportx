require 'spec_helper'

module StatusReportx
  describe Report do
    it "should be OK" do
      c = FactoryGirl.build(:status_reportx_report)
      c.should be_valid
    end
    
    it "should reject nil thing_did" do
      c = FactoryGirl.build(:status_reportx_report, :thing_did => nil)
      c.should_not be_valid
    end
    
    it "should reject nil report_date" do
      c = FactoryGirl.build(:status_reportx_report, :report_date => nil)
      c.should_not be_valid
    end
    
    it "should reject nil report for" do
      c = FactoryGirl.build(:status_reportx_report, :report_for => nil)
      c.should_not be_valid
    end
    
    it "should reject nil resource_id" do
      c = FactoryGirl.build(:status_reportx_report, :resource_id => nil)
      c.should_not be_valid
    end
    
    it "should reject nil resource_string" do
      c = FactoryGirl.build(:status_reportx_report, :resource_string => nil)
      c.should_not be_valid
    end
  end
end
