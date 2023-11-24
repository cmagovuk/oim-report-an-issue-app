class ReportIssue::IssueImpact < ReportIssue
  validates :issue_impact, presence: true

  def permitted
    %w[issue_impact].freeze
  end
end
