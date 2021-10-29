class ReportIssue::OrgArea < ReportIssue
  validate :atleast_one_selected

  AREA_OPTIONS = %w[england ni scotland wales].freeze

  def permitted
    [area_of_ops: []].freeze
  end

  def atleast_one_selected
    errors.add(:area_of_ops, "Select at least one area") unless AREA_OPTIONS.any? { |a| area_of_ops.include?(a.to_s) }
  end
end
