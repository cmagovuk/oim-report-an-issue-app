class ReportIssue < ApplicationRecord
  has_many_attached :supporting_docs

  serialize :area_of_ops, Array
  serialize :impact_area, Array
  serialize :completed_steps, Array

  def individual_reporting?
    reporting_as == "ind" || reporting_as == "other"
  end

  def permitted
    %w[].freeze
  end

  # allow pages that don't update object, such as information and confirmation pages
  def info_only?
    permitted.empty?
  end

  def upload_step?
    false
  end

  def formatted_address
    remove_blanks addr_line_1, addr_line_2, addr_town, addr_county, addr_postcode
  end

  def get_filenames
    get_filenames = []
    if supporting_docs.attached?
      supporting_docs.each do |single|
        get_filenames.push(single.filename)
      end
    else
      get_filenames.push(I18n.t("report_issue_steps.summary.no_files"))
    end
    get_filenames
  end

  def contact_details
    remove_blanks "#{first_name} #{last_name}", email, telephone
  end

  def reporting_as_data
    remove_blanks reporting_as_text, reporting_other
  end

  def reporting_as_text
    I18n.t(reporting_as&.to_sym, scope: %i[helpers label issue reporting_as_options])
  end

  def area_of_ops_text
    translate_terms(area_of_ops, "area_of_ops_options")
  end

  def issue_areas_text
    translate_terms(impact_area, "impact_area_options")
  end

  def issue_areas_data
    remove_blanks issue_areas_text.join(", "), impact_other
  end

  def self.purge!(date)
    where(
      "report_issues.created_at <= :date", date: date
    ).where(
      "report_issues.updated_at <= :date", date: 45.minutes.ago
    ).destroy_all
  end

private

  def remove_blanks(*args)
    args.select(&:present?)
  end

  def translate_terms(terms, translation_scope)
    compact_terms = terms.select(&:present?)
    compact_terms.map { |t| I18n.t "helpers.label.issue.#{translation_scope}.#{t}" }
  end
end
