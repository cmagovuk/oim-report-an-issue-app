class ReportIssue::ReportingAs < ReportIssue
  validates :reporting_as, presence: true
  validates :reporting_other, presence: { if: ->(o) { o.reporting_as == "other" } }, length: { maximum: 255 }

  REPORTING_AS_OPTIONS = %w[ind con business pb tu cg other].freeze

  validates :reporting_as, inclusion: { in: REPORTING_AS_OPTIONS }

  def permitted
    %w[reporting_as reporting_other].freeze
  end
end
