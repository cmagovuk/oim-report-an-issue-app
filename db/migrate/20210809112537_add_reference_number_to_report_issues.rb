class AddReferenceNumberToReportIssues < ActiveRecord::Migration[6.1]
  def change
    add_column :report_issues, :reference_number, :string
  end
end
