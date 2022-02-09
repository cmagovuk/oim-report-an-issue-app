class ReportIssueStepsController < ApplicationController
  before_action :load_issue
  before_action :redirect_completed
  include ReportIssueStepsHelper

  def edit
    if wf.step_valid?
      render step
    else
      render "/errors/not_found", status: :not_found
    end
  end

  def update
    if step_model.upload_step?
      process_upload
    elsif step_model.info_only? || step_model.update(form_params)
      wf.update_completed_steps
      if next_step
        redirect_to report_issue_step_path(next_step)
      elsif wf.completed_steps?
        result = submit_service.result
        if result.present?
          step_model.update!(reference_number: result.to_s)
          ReportIssues::GovukNotifyService.send_email(step_model) if step_model.email.present? && step_model.reference_number.present?
          redirect_to report_issue_submitted_path
        else
          Rails.logger.warn "Failed to submit issue"
          render "/errors/internal_server_error", status: :internal_server_error
        end
      else
        redirect_to edit_report_issue_step_path(wf.missed_step)
      end
    else
      Rails.logger.warn "Failed to save issue step"
      render step
    end
  end

  def set_headers
    response.set_header("X-Robots-Tag", "noindex, nofollow")
  end

  helper_method :previous_step_path, :step, :step_path

private

  def previous_step_path
    return step_path(wf.previous_step) if wf.previous_step

    root_path
  end

  def step_path(current_step)
    edit_report_issue_step_path(current_step)
  end

  def process_upload
    if params.key?(:doc_id)
      begin
        document = step_model.supporting_docs.find(params[:doc_id])
        document.purge
      rescue ActiveRecord::RecordNotFound
        # Document already removed, do nothing and redirect back
      end
      redirect_to edit_report_issue_step_path(step)

    elsif params.key?(:issue)
      if params[:issue].key?(:continue)
        wf.update_completed_steps
        redirect_to edit_report_issue_step_path(next_step)

      else
        if step_model.valid_document?(params[:issue][:documents])
          step_model.supporting_docs.attach(params[:issue][:documents])
        end
        render step
      end
    else
      step_model.errors.add(:documents, I18n.t("errors.upload.no_file_error_message"))
      render step
    end
  end

  def load_issue
    @issue = step_model
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def form_params
    params.require(:issue).permit(@issue.permitted)
  end

  def submit_service
    @submit_service ||= ReportIssues::SubmitReportService.new(@issue)
  end

  def redirect_completed
    redirect_to report_issue_submitted_path if step_model.reference_number.present?
  end

  delegate :step, :step_model, :next_step, to: :wf

  def wf
    @wf ||= ReportIssues::StepWorkflow.new(request)
  end
end
