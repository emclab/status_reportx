# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :status_reportx_report, :class => 'StatusReportx::Report' do
    resource_id 1
    resource_string "MyString"
    last_updated_by_id 1
    reported_by_id 1
    report_date "2014-04-18"
    thing_did "MyText"
    issue_to_solve "MyText"
    thing_to_do "MyText"
    status_update "MyText"
    report_from_date "2014-04-18"
    report_to_date "2014-04-18"
    report_category_id 1
    report_for 'installation'
    fort_token '123456789'
  end
end
