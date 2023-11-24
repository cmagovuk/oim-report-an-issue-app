class ReportIssue::IssueDescribe < ReportIssue
  validates :issue_description, presence: true

  def permitted
    %w[issue_description].freeze
  end
end
