class ReportIssue::IssueReported < ReportIssue
  validates :issue_reported, presence: true

  def permitted
    %w[issue_reported].freeze
  end
end
