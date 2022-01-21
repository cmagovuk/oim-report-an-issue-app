require "rails_helper"
ORG_STEPS = %w[reporting_as org_name postcode org_area org_sector issue issue_areas supporting_documents contact_details summary].freeze
IND_STEPS = %w[reporting_as postcode issue issue_areas supporting_documents contact_details summary].freeze

RSpec.describe ReportIssues::StepWorkflow do
  subject { described_class.new(request) }

  let(:request) { double("Request") }

  describe "#first_step" do
    it "returns the first step" do
      expect(subject.first_step).to eq "reporting_as"
    end
  end

  describe "#step" do
    it "returns current step" do
      allow(request).to receive(:params).and_return({ id: "contact_details" })
      expect(subject.step).to eq "contact_details"
    end
  end

  describe "#step_valid?" do
    before do
      issue = ReportIssue::ReportingAs.new(reporting_as: "business")
      allow(subject).to receive(:step_model).and_return(issue)
    end
    it "returns false if not a know step name" do
      allow(request).to receive(:params).and_return({ id: "unknown_step" })
      expect(subject).to_not be_step_valid
    end

    it "returns false if not a know step name" do
      allow(request).to receive(:params).and_return({ id: IND_STEPS[0] })
      expect(subject).to be_step_valid
    end
  end

  describe "#completed_steps?" do
    context "business users" do
      it "completed if all business steps completed" do
        issue = ReportIssue.new(reporting_as: "business", completed_steps: ORG_STEPS)
        allow(subject).to receive(:step_model).and_return(issue)
        expect(subject).to be_completed_steps
      end

      it "not completed if any steps missing" do
        issue = ReportIssue.new(reporting_as: "business", completed_steps: %w[contact_details reporting_as org_name address org_area org_sector issue issue_areas].freeze)
        allow(subject).to receive(:step_model).and_return(issue)
        expect(subject).to_not be_completed_steps
      end

      context "individual users" do
        it "completed if all business steps completed" do
          issue = ReportIssue.new(reporting_as: "ind", completed_steps: IND_STEPS)
          allow(subject).to receive(:step_model).and_return(issue)
          expect(subject).to be_completed_steps
        end

        it "not completed if any steps missing" do
          issue = ReportIssue.new(reporting_as: "business", completed_steps: %w[contact_details reporting_as address issue issue_areas].freeze)
          allow(subject).to receive(:step_model).and_return(issue)
          expect(subject).to_not be_completed_steps
        end
      end
    end
  end

  describe "#missed_step" do
    it "returns next missing step" do
      issue = ReportIssue.new(reporting_as: "business", completed_steps: %w[contact_details reporting_as org_name issue issue_areas].freeze)
      allow(subject).to receive(:step_model).and_return(issue)
      expect(subject.missed_step).to eq "postcode"
    end

    it "returns nil if all steps completed" do
      issue = ReportIssue.new(reporting_as: "ind", completed_steps: IND_STEPS)
      allow(subject).to receive(:step_model).and_return(issue)
      expect(subject.missed_step).to be_nil
    end
  end

  describe "#next_step" do
    context "when complete" do
      it "alway return the last step" do
        issue = ReportIssue.new(reporting_as: "business", completed_steps: ORG_STEPS)
        allow(subject).to receive(:step_model).and_return(issue)
        allow(request).to receive(:params).and_return({ id: ORG_STEPS[4] })
        expect(subject.next_step).to eq ORG_STEPS[-1]
      end
    end

    context "when not complete" do
      it "alway return the next step if there is one" do
        issue = ReportIssue.new(reporting_as: "business", completed_steps: %w[contact_details].freeze)
        allow(subject).to receive(:step_model).and_return(issue)
        allow(request).to receive(:params).and_return({ id: ORG_STEPS[4] })
        expect(subject.next_step).to eq ORG_STEPS[5]
      end

      it "return nil if no step" do
        issue = ReportIssue.new(reporting_as: "business", completed_steps: %w[contact_details].freeze)
        allow(subject).to receive(:step_model).and_return(issue)
        allow(request).to receive(:params).and_return({ id: ORG_STEPS[-1] })
        expect(subject.next_step).to be_nil
      end
    end
  end

  describe "#previous_step" do
    context "when complete" do
      it "alway return the last step" do
        issue = ReportIssue.new(reporting_as: "business", completed_steps: ORG_STEPS)
        allow(subject).to receive(:step_model).and_return(issue)
        allow(request).to receive(:params).and_return({ id: ORG_STEPS[4] })
        expect(subject.previous_step).to eq ORG_STEPS[-1]
      end
    end

    context "when not complete" do
      it "alway return the previous step if there is one" do
        issue = ReportIssue.new(reporting_as: "business", completed_steps: %w[contact_details].freeze)
        allow(subject).to receive(:step_model).and_return(issue)
        allow(request).to receive(:params).and_return({ id: ORG_STEPS[4] })
        expect(subject.previous_step).to eq ORG_STEPS[3]
      end

      it "return nil if no step" do
        issue = ReportIssue.new(reporting_as: "business", completed_steps: %w[contact_details].freeze)
        allow(subject).to receive(:step_model).and_return(issue)
        allow(request).to receive(:params).and_return({ id: ORG_STEPS[0] })
        expect(subject.previous_step).to be_nil
      end
    end
  end
end
