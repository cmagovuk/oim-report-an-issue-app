require "rails_helper"

RSpec.describe ReportIssue::IssueAreas, type: :model do
  describe "validations" do
    it { should validate_presence_of(:impact_area) }

    it { should allow_value(%w[england]).for(:impact_area) }
    it { should allow_value(%w[england ni wales]).for(:impact_area) }
    it { should_not allow_value(%w[illegal]).for(:impact_area) }

    it "is not valid if other selected and no additional details" do
      subject = described_class.new(impact_area: %w[other])
      expect(subject).to_not be_valid
    end

    it "is not valid if other selected and no additional details" do
      subject = described_class.new(impact_area: %w[england other])
      expect(subject).to_not be_valid
    end

    it "is not valid if other selected and no additional details" do
      subject = described_class.new(impact_area: %w[other], impact_other: "Other text")
      expect(subject).to be_valid
    end

    it "is not valid if other selected and no additional details" do
      subject = described_class.new(impact_area: %w[england other], impact_other: "Other text")
      expect(subject).to be_valid
    end

    it "is valid if other not selected for additional details to not be present" do
      subject = described_class.new(impact_area: %w[england])
      expect(subject).to be_valid
    end
  end

  describe "#info_only?" do
    it "must not be info only view" do
      expect(subject).to_not be_info_only
    end
  end
end
