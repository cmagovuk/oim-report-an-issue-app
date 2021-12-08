require "rails_helper"

RSpec.describe ReportIssue::OrgSector, type: :model do
  describe "validations" do
    it "is valid empty is reporting as is not business" do
      subject = described_class.new
      expect(subject).to be_valid
    end

    it "must be present if reporting as is business" do
      subject = described_class.new(reporting_as: "business")
      expect(subject).to_not be_valid
    end

    it "must be present if reporting as is business" do
      subject = described_class.new(reporting_as: "business", business_sector: "Sector")
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
