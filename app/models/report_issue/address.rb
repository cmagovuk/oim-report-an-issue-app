class ReportIssue::Address < ReportIssue
  validates :addr_line_1, length: { maximum: 255 }
  validates :addr_line_2, length: { maximum: 255 }
  validates :addr_town, presence: true, length: { maximum: 255 }
  validates :addr_county, length: { maximum: 50 }
  validates :addr_postcode, presence: true, length: { maximum: 10 }

  def permitted
    %w[addr_line_1 addr_line_2 addr_town addr_county addr_postcode].freeze
  end
end
