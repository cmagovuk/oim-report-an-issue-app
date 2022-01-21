class ReportIssuesController < ApplicationController
  def show
    @issue = ReportIssue.find(session[:issue_id])
  end

  def index; end

  def create
    @report_issue = ReportIssue.new
    if @report_issue.save(validation: false)
      session[:issue_id] = @report_issue.id
      # hand control to first step in multi-step form
      redirect_to edit_report_issue_step_path(wf.first_step)
    else
      Rails.logger.warn "Failed to save issue"
      render "index"
    end
  end

private

  def wf
    @wf ||= ReportIssues::StepWorkflow.new(request)
  end
end
