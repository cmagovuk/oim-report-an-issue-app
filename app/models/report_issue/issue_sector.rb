class ReportIssue::IssueSector < ReportIssue
  validates :issue_sector, presence: true

  def permitted
    %w[issue_sector].freeze
  end
end
