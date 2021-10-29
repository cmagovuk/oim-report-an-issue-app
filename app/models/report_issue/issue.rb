class ReportIssue::Issue < ReportIssue
  validates :issue, presence: true

  def permitted
    %w[issue].freeze
  end
end
