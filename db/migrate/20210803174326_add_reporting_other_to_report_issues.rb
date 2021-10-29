class AddReportingOtherToReportIssues < ActiveRecord::Migration[6.1]
  def change
    add_column :report_issues, :reporting_other, :text
  end
end
