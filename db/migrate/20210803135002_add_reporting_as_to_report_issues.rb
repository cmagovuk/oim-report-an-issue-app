class AddReportingAsToReportIssues < ActiveRecord::Migration[6.1]
  def change
    add_column :report_issues, :reporting_as, :string
  end
end
