class CreateReportIssues < ActiveRecord::Migration[6.1]
  def change
    create_table :report_issues, id: :uuid do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.boolean :completed
      t.boolean :submitted
      t.text :issue

      t.timestamps
    end
  end
end
