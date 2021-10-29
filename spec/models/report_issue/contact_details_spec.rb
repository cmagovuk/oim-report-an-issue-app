require "rails_helper"

RSpec.describe ReportIssue::ContactDetails, type: :model do
  describe "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }

    it { should validate_length_of(:first_name).is_at_most(255) }
    it { should validate_length_of(:last_name).is_at_most(255) }
    it { should validate_length_of(:email).is_at_most(255) }
    it { should validate_length_of(:telephone).is_at_most(30) }

    it { should allow_value("name@company.com").for(:email) }
    it { should allow_value("nAmE@comPany.COM").for(:email) }
    it { should_not allow_value("name@company@company.com").for(:email) }

    it { should_not allow_value("abc.def@mail").for(:email) }
    it { should_not allow_value("abc.def@mail.c").for(:email) }

    it { should allow_value("01632 960 001").for(:telephone) }
    it { should allow_value("+44 0808 157 0192").for(:telephone) }
    it { should allow_value("01632-960-001").for(:telephone) }
    it { should allow_value("077 00 90 0982").for(:telephone) }
    it { should_not allow_value("++44 0808 157 0192").for(:telephone) }
    it { should_not allow_value("Who you going to call?").for(:telephone) }

    it "is not valid unless a email or phone number is present" do
      subject = described_class.new(first_name: "First", last_name: "Last")
      expect(subject).to_not be_valid
    end

    it "is valid with email and no phone number" do
      subject = described_class.new(first_name: "First", last_name: "Last", email: "name@company.com")
      expect(subject).to be_valid
    end

    it "is valid with phone number and no email" do
      subject = described_class.new(first_name: "First", last_name: "Last", telephone: "01632 960 001")
      expect(subject).to be_valid
    end

    it "is valid with both phone number and email" do
      subject = described_class.new(first_name: "First", last_name: "Last", email: "name@company.com", telephone: "01632 960 001")
      expect(subject).to be_valid
    end

    describe "#info_only?" do
      it "must not be info only view" do
        expect(subject).to_not be_info_only
      end
    end
  end
end
