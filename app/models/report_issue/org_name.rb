class ReportIssue::OrgName < ReportIssue
  validates :org_name, presence: true, length: { maximum: 255 }

  def permitted
    %w[org_name].freeze
  end
end
