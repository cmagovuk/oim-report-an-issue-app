class AddExtraFieldsToReportIssues < ActiveRecord::Migration[6.1]
  def change
    change_table :report_issues, bulk: true do |t|
      t.text :issue_sector
      t.text :issue_description
      t.text :issue_impact
      t.text :issue_regs
      t.text :issue_reported
    end
  end
end
