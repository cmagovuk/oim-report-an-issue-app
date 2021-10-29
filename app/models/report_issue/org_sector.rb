class ReportIssue::OrgSector < ReportIssue
  validates :business_sector, presence: { if: ->(o) { o.reporting_as == "business" } }

  def permitted
    %w[business_sector].freeze
  end
end
