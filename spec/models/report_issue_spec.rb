require "rails_helper"

RSpec.describe ReportIssue, type: :model do
  describe "#info_only?" do
    it "must be info only view" do
      expect(subject).to be_info_only
    end
  end

  describe "#individual_reporting?" do
    context "when reporting as individual or other" do
      it "must be individual" do
        subject = described_class.new(reporting_as: "ind")
        expect(subject).to be_individual_reporting
      end

      it "must be individual" do
        subject = described_class.new(reporting_as: "other")
        expect(subject).to be_individual_reporting
      end
    end

    context "otherwise not an individual" do
      it "must not be individual if reporting as business" do
        subject = described_class.new(reporting_as: "business")
        expect(subject).to_not be_individual_reporting
      end

      it "must not be individual if reporting as trade union" do
        subject = described_class.new(reporting_as: "tu")
        expect(subject).to_not be_individual_reporting
      end
    end
  end

  describe "#formatted_address" do
    it "must remove any nil or empty address lines" do
      subject = described_class.new(addr_line_1: nil, addr_line_2: "Line 2", addr_town: "London", addr_county: "", addr_postcode: "GIR0")
      expect(subject.formatted_address).to eq ["Line 2", "London", "GIR0"]
    end
  end

  describe "#contact_details" do
    it "must remove any nil or empty contact details" do
      subject = described_class.new(first_name: "John", last_name: "Smith", email: "", telephone: "01632 960001")
      expect(subject.contact_details).to eq ["John Smith", "01632 960001"]
    end
  end

  describe "#reporting_as_data" do
    it "must remove any nil or empty additional text" do
      subject = described_class.new(reporting_as: "ind")
      expect(subject.reporting_as_data).to eq ["an individual professional or consumer"]
    end

    it "must return 2 elements when additional text included" do
      subject = described_class.new(reporting_as: "tu", reporting_other: "Other text")
      expect(subject.reporting_as_data).to eq ["a trade union", "Other text"]
    end
  end

  describe "#reporting_as_text" do
    it "must return locale text for reporting as" do
      subject = described_class.new(reporting_as: "ind")
      expect(subject.reporting_as_text).to eq "an individual professional or consumer"
    end

    it "must return locale text for reporting as" do
      subject = described_class.new(reporting_as: "tu")
      expect(subject.reporting_as_text).to eq "a trade union"
    end
  end

  describe "#area_of_ops_text" do
    it "must return locale text for Areas of operations" do
      subject = described_class.new(area_of_ops: %w[england ni scotland])
      expect(subject.area_of_ops_text).to eq ["England", "Northern Ireland", "Scotland"]
    end

    it "must ignore nil or empty array elements" do
      subject = described_class.new(area_of_ops: ["ni", nil, "", "wales"])
      expect(subject.area_of_ops_text).to eq ["Northern Ireland", "Wales"]
    end
  end

  describe "#issue_areas_text" do
    it "must return locale text for Areas of operations" do
      subject = described_class.new(impact_area: %w[england ni wales])
      expect(subject.issue_areas_text).to eq ["England", "Northern Ireland", "Wales"]
    end

    it "must ignore nil or empty array elements" do
      subject = described_class.new(impact_area: ["ni", nil, "", "scotland"])
      expect(subject.issue_areas_text).to eq ["Northern Ireland", "Scotland"]
    end
  end

  describe "#issue_areas_data" do
    it "must return only areas as comma separated string if nil or empty additional text" do
      subject = described_class.new(impact_area: %w[england wales])
      expect(subject.issue_areas_data).to eq ["England, Wales"]
    end

    it "must return locale text areas as comma separated string and additional text element when additional text included" do
      subject = described_class.new(impact_area: %w[ni scotland], impact_other: "Other text")
      expect(subject.issue_areas_data).to eq ["Northern Ireland, Scotland", "Other text"]
    end
  end
end
