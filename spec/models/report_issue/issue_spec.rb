require "rails_helper"

RSpec.describe ReportIssue::Issue, type: :model do
  describe "validations" do
    it { should validate_presence_of(:issue) }
  end

  describe "#info_only?" do
    it "must not be info only view" do
      expect(subject).to_not be_info_only
    end
  end
end
