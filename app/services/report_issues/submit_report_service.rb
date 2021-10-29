class ReportIssues::SubmitReportService
  require "faraday_middleware"

  URL_ENV = "REPORT_ISSUE_API".freeze

  def initialize(issue)
    @issue = issue
  end

  def result
    @result ||= submit_issue
  end

  def submit_issue
    if ENV.key?(URL_ENV)
      call_api
    end
  end

private

  def call_api
    docs = []
    if @issue.supporting_docs.attached?
      @issue.supporting_docs.each do |single|
        docs.push({ key: single.key, filename: single.filename })
      end
    end

    body = {
      method: "Issue.Submit",
      payload: {
        record: @issue,
        documents: docs,
      },
    }.to_json

    url = ENV.fetch(URL_ENV)

    conn = Faraday.new do |f|
      f.response :json # decode response body as JSON
    end

    response = conn.post(url, body, "Content-Type" => "application/json")
    if response.body["success"]
      response.body["data"]
    else
      Rails.logger.warn "API failed"
      Rails.logger.warn response.body["error"] if response.body["error"].present?
      nil
    end
  end
end
