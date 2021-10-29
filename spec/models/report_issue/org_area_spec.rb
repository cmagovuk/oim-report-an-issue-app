require "rails_helper"

RSpec.describe ReportIssue::OrgArea, type: :model do
  describe "validations" do
    it { should allow_value(%w[england]).for(:area_of_ops) }
    it { should_not allow_value(%w[illegal]).for(:area_of_ops) }
    it { should_not allow_value([]).for(:area_of_ops) }
    it { should_not allow_value(nil).for(:area_of_ops) }
  end

  describe "#info_only?" do
    it "must not be info only view" do
      expect(subject).to_not be_info_only
    end
  end
end
