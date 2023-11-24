class ReportIssue::IssueRegs < ReportIssue
  validates :issue_regs, presence: true

  def permitted
    %w[issue_regs].freeze
  end
end
