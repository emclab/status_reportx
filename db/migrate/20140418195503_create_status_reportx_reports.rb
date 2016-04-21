class CreateStatusReportxReports < ActiveRecord::Migration
  def change
    create_table :status_reportx_reports do |t|
      t.integer :resource_id
      t.string :resource_string
      t.integer :last_updated_by_id
      t.integer :reported_by_id
      t.date :report_date
      t.text :thing_did
      t.text :issue_to_solve
      t.text :thing_to_do
      t.text :status_update
      t.date :report_from_date
      t.date :report_to_date
      t.integer :report_category_id
      t.string :report_for
      t.string :wf_state
      t.timestamps
      t.string :fort_token
    end
    
    add_index :status_reportx_reports, [:resource_id, :resource_string], :name => :report_resource_id_n_string
    add_index :status_reportx_reports, :resource_id
    add_index :status_reportx_reports, :resource_string
    add_index :status_reportx_reports, :report_category_id
    add_index :status_reportx_reports, :reported_by_id
    add_index :status_reportx_reports, :wf_state
    add_index :status_reportx_reports, :report_for
    add_index :status_reportx_reports, :fort_token
  end
end
