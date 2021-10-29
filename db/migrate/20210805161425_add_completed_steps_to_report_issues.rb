class AddCompletedStepsToReportIssues < ActiveRecord::Migration[6.1]
  def change
    add_column :report_issues, :completed_steps, :string
  end
end
