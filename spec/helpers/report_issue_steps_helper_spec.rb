require "rails_helper"

RSpec.describe ReportIssueStepsHelper, type: :helper do
  describe "#truncate_text" do
    it "returns full string when less than 260 characters" do
      str_value = "abcd"
      expect(helper.truncate_text(str_value)).to eq str_value
    end

    it "returns 260 characters when greater than 260 characters" do
      str_value = "abcdefghij" * 29
      expect(helper.truncate_text(str_value).size).to eq 260
    end

    it "finishes with ... if over 260 characters" do
      str_value = "abcdefghij" * 29
      expect(helper.truncate_text(str_value)[-3, 3]).to eq "..."
    end
  end
end
