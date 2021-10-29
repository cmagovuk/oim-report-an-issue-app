class ReportIssuesController < ApplicationController
  include ReportIssueStepsHelper

  def show
    # @issue = ReportIssue.find(params[:id])
    @issue = ReportIssue.find(session[:issue_id])
  end

  def index; end

  def create
    # ReportIssue.purge!(30.day.ago)
    @report_issue = ReportIssue.new
    if @report_issue.save(validation: false)
      session[:issue_id] = @report_issue.id
      # hand control to first step in multi-step form
      redirect_to edit_report_issue_step_path(first_step)
    else
      flash[:error] = "Something went wrong"
      render "index"
    end
  end
end
