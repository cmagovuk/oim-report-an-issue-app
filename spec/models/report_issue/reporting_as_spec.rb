require "rails_helper"

RSpec.describe ReportIssue::ReportingAs, type: :model do
  describe "validations" do
    it { should validate_presence_of(:reporting_as) }

    it { should allow_value("business").for(:reporting_as) }
    it { should_not allow_value("england").for(:reporting_as) }

    it "is not valid if other selected and no additional details" do
      subject = described_class.new(reporting_as: "other")
      expect(subject).to_not be_valid
    end

    it "is valid if other selected and no additional details are present" do
      subject = described_class.new(reporting_as: "other", reporting_other: "Other text")
      expect(subject).to be_valid
    end

    it "is valid if other not selected for additional details to not be present" do
      subject = described_class.new(reporting_as: "ind")
      expect(subject).to be_valid
    end
  end

  describe "#info_only?" do
    it "must not be info only view" do
      expect(subject).to_not be_info_only
    end
  end

  describe "#upload_step?" do
    it "must not be upload step" do
      expect(subject).to_not be_upload_step
    end
  end
end
