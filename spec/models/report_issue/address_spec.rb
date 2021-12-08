require "rails_helper"

RSpec.describe ReportIssue::Address, type: :model do
  describe "validations" do
    it { should validate_presence_of(:addr_town) }
    it { should validate_presence_of(:addr_postcode) }

    it { should validate_length_of(:addr_line_1).is_at_most(255) }
    it { should validate_length_of(:addr_line_2).is_at_most(255) }
    it { should validate_length_of(:addr_town).is_at_most(255) }
    it { should validate_length_of(:addr_county).is_at_most(50) }
    it { should validate_length_of(:addr_postcode).is_at_most(10) }
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
