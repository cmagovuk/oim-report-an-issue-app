require "rails_helper"

RSpec.describe ReportIssue::Postcode, type: :model do
  describe "validations" do
    it { should validate_presence_of(:addr_postcode) }

    it { should validate_length_of(:addr_postcode).is_at_most(10) }
  end

  describe "#info_only?" do
    it "must not be info only view" do
      expect(subject).to_not be_info_only
    end
  end
end
