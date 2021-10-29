require "rails_helper"

RSpec.describe ReportIssue::OrgName, type: :model do
  describe "validations" do
    it { should validate_presence_of(:org_name) }
    it { should validate_length_of(:org_name).is_at_most(255) }
  end

  describe "#info_only?" do
    it "must not be info only view" do
      expect(subject).to_not be_info_only
    end
  end
end
