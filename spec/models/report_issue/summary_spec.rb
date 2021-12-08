require "rails_helper"

RSpec.describe ReportIssue::Summary, type: :model do
  describe "#permitted" do
    it "cannot permit any fields" do
      expect(subject.permitted).to be_empty
    end
  end

  describe "#info_only?" do
    it "must be info only view" do
      expect(subject).to be_info_only
    end
  end

  describe "#upload_step?" do
    it "must not be upload step" do
      expect(subject).to_not be_upload_step
    end
  end
end
