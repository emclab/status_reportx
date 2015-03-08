require 'rails_helper'

module StatusReportx
  RSpec.describe Report, type: :model do
    it "should be OK" do
      c = FactoryGirl.build(:status_reportx_report)
      expect(c).to be_valid
    end
    
    it "should reject nil thing_did" do
      c = FactoryGirl.build(:status_reportx_report, :thing_did => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject nil report_for" do
      c = FactoryGirl.build(:status_reportx_report, :report_for => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject nil report_date" do
      c = FactoryGirl.build(:status_reportx_report, :report_date => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject nil resource_id" do
      c = FactoryGirl.build(:status_reportx_report, :resource_id => nil)
      expect(c).not_to be_valid
    end
    
    it "should reject nil resource_string" do
      c = FactoryGirl.build(:status_reportx_report, :resource_string => nil)
      expect(c).not_to be_valid
    end
  end
end
