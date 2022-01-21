module ReportIssueStepsHelper
  def truncate_text(text)
    truncate(text, separator: " ", length: 260)
  end
end
