class ReportIssues::GovukNotifyService
  require "notifications/client"

  def self.send_email(issue)
    template_id = Rails.application.config.govuk_notify_templates.fetch(issue.individual_reporting? ? :submit_individual : :submit_organisation)
    if api_key.present? && template_id.present?
      notify_client.send_email(
        email_address: issue.email,
        template_id: template_id,
        personalisation: {
          submitter_name: submitter_name(issue),
          reference_number: issue.reference_number,
          contact_details: issue.contact_details.join("\n"),
          postcode: issue.addr_postcode,
          reporting_as: issue.reporting_as_data.join("\n"),
          organisation_name: issue.org_name,
          organisation_areas: issue.area_of_ops_text.join(", "),
          issue_sector: issue.issue_sector,
          issue_description: issue.issue_description,
          issue_impact: issue.issue_impact,
          issue_regs: issue.issue_regs,
          issue_reported: issue.issue_reported,
          issue_impact_areas: issue.issue_areas_data.join("\n"),
          operating_sector: issue.business_sector,
          documents: issue.get_filenames.join("\n"),
        },
      )

    end
  rescue Notifications::Client::BadRequestError => e
    # silently ignore failure to send email
    Rails.logger.warn "Failed to send email #{e.message}"
  end

  private_class_method def self.notify_client
    @notify_client || Notifications::Client.new(api_key)
  end

  private_class_method def self.api_key
    @api_key || ENV["GOVUK_NOTIFY_API_KEY"]
  end

  private_class_method def self.submitter_name(issue)
    if issue.first_name.blank? || issue.last_name.blank?
      I18n.t("services.govuk_notify_service.anonymous_username")
    else
      "#{issue.first_name} #{issue.last_name}"
    end
  end
end
