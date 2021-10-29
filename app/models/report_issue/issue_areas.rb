class ReportIssue::IssueAreas < ReportIssue
  validate :atleast_one_selected
  validates :impact_other, presence: { if: ->(o) { o.impact_area.include?("other") } }, length: { maximum: 255 }

  ISSUE_AREA_OPTIONS = %w[england ni scotland wales other].freeze

  def permitted
    [:impact_other, { impact_area: [] }].freeze
  end

  def atleast_one_selected
    errors.add(:impact_area, :blank) unless ISSUE_AREA_OPTIONS.any? { |a| impact_area.include?(a.to_s) }
  end
end
