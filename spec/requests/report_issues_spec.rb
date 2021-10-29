require "rails_helper"

RSpec.describe "ReportIssues", type: :request do
  context "when no maintenance" do
    before do
      allow(Rails.application.config.x).to receive(:maintenance_text).and_return("")
    end
    describe "GET /index" do
      it "returns http success" do
        get "/report_issues"
        expect(response).to have_http_status(:success)
      end
    end
  end

  context "when maintenance" do
    before do
      allow(Rails.application.config.x).to receive(:maintenance_text).and_return("Maintenance")
    end
    describe "GET /index" do
      it "returns http success" do
        get "/report_issues"
        expect(response).to have_http_status(:service_unavailable)
      end
    end
  end
end
