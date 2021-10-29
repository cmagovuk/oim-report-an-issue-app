class AddPhoneToReportIssue < ActiveRecord::Migration[6.1]
  def change
    add_column :report_issues, :telephone, :string
  end
end
