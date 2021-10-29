class AddFieldsToReportIssues < ActiveRecord::Migration[6.1]
  def change
    add_column :report_issues, :addr_line_1, :string
    add_column :report_issues, :addr_line_2, :string
    add_column :report_issues, :addr_town, :string
    add_column :report_issues, :addr_county, :string
    add_column :report_issues, :addr_postcode, :string
    add_column :report_issues, :org_name, :string
    add_column :report_issues, :area_of_ops, :string
    add_column :report_issues, :business_sector, :text
    add_column :report_issues, :impact_area, :string
    add_column :report_issues, :impact_other, :text
  end
end
