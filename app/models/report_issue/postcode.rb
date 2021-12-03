class ReportIssue::Postcode < ReportIssue
  validates :addr_postcode, presence: true, length: { maximum: 10 }

  def permitted
    %w[addr_postcode].freeze
  end
end
