require "rails_helper"
ORG_STEPS = %w[contact_details reporting_as org_name address org_area org_sector issue issue_areas supporting_documents summary].freeze
IND_STEPS = %w[contact_details reporting_as address issue issue_areas supporting_documents summary].freeze

RSpec.describe ReportIssueStepsHelper, type: :helper do
  describe "#first_step" do
    it "returns the first step" do
      expect(helper.first_step).to eq "contact_details"
    end
  end

  describe "#step" do
    it "returns current step" do
      assign(:step, "contact_details")
      expect(helper.step).to eq "contact_details"
    end
  end

  describe "#step_valid?" do
    before do
      issue = ReportIssue::ReportingAs.new(reporting_as: "business")
      assign(:step_model, issue)
    end
    it "returns false if not a know step name" do
      assign(:step, "unknown_step")
      expect(helper).to_not be_step_valid
    end

    it "returns false if not a know step name" do
      assign(:step, IND_STEPS[0])
      expect(helper).to be_step_valid
    end
  end

  describe "#truncate_text" do
    it "returns full string when less than 260 characters" do
      str_value = "abcd"
      expect(helper.truncate_text(str_value)).to eq str_value
    end

    it "returns 260 characters when greater than 260 characters" do
      str_value = "abcdefghij" * 29
      expect(helper.truncate_text(str_value).size).to eq 260
    end

    it "finishes with ... if over 260 characters" do
      str_value = "abcdefghij" * 29
      expect(helper.truncate_text(str_value)[-3, 3]).to eq "..."
    end
  end

  describe "#upload_step?" do
    it "returns true if not a upload step" do
      assign(:step, "supporting_documents")
      expect(helper).to be_upload_step
    end

    it "returns false if not a upload step" do
      assign(:step, "contact_details")
      expect(helper).to_not be_upload_step
    end
  end

  describe "#step_set" do
    it "excludes organisation pages when individual" do
      issue = ReportIssue::ReportingAs.new(reporting_as: "ind")
      assign(:step_model, issue)
      expect(helper.step_set).to eq IND_STEPS
    end

    it "includes organisation pages when business" do
      issue = ReportIssue::ReportingAs.new(reporting_as: "business")
      assign(:step_model, issue)
      expect(helper.step_set).to eq ORG_STEPS
    end
  end

  describe "#completed_steps?" do
    context "business users" do
      it "completed if all business steps completed" do
        issue = ReportIssue.new(reporting_as: "business", completed_steps: ORG_STEPS)
        assign(:step_model, issue)
        expect(helper).to be_completed_steps
      end

      it "not completed if any steps missing" do
        issue = ReportIssue.new(reporting_as: "business", completed_steps: %w[contact_details reporting_as org_name address org_area org_sector issue issue_areas].freeze)
        assign(:step_model, issue)
        expect(helper).to_not be_completed_steps
      end

      context "individual users" do
        it "completed if all business steps completed" do
          issue = ReportIssue.new(reporting_as: "ind", completed_steps: IND_STEPS)
          assign(:step_model, issue)
          expect(helper).to be_completed_steps
        end

        it "not completed if any steps missing" do
          issue = ReportIssue.new(reporting_as: "business", completed_steps: %w[contact_details reporting_as address issue issue_areas].freeze)
          assign(:step_model, issue)
          expect(helper).to_not be_completed_steps
        end
      end
    end
  end

  describe "#missed_step" do
    it "returns next missing step" do
      issue = ReportIssue.new(reporting_as: "business", completed_steps: %w[contact_details reporting_as org_name issue issue_areas].freeze)
      assign(:step_model, issue)
      expect(helper.missed_step).to eq "address"
    end

    it "returns nil if all steps completed" do
      issue = ReportIssue.new(reporting_as: "ind", completed_steps: IND_STEPS)
      assign(:step_model, issue)
      expect(helper.missed_step).to be_nil
    end
  end

  describe "#next_step" do
    context "when complete" do
      it "alway return the last step" do
        issue = ReportIssue.new(reporting_as: "business", completed_steps: ORG_STEPS)
        assign(:step_model, issue)
        assign(:step, ORG_STEPS[4])
        expect(helper.next_step).to eq ORG_STEPS[-1]
      end
    end

    context "when not complete" do
      it "alway return the next step if there is one" do
        issue = ReportIssue.new(reporting_as: "business", completed_steps: %w[contact_details].freeze)
        assign(:step_model, issue)
        assign(:step, ORG_STEPS[4])
        expect(helper.next_step).to eq ORG_STEPS[5]
      end

      it "return nil if no step" do
        issue = ReportIssue.new(reporting_as: "business", completed_steps: %w[contact_details].freeze)
        assign(:step_model, issue)
        assign(:step, ORG_STEPS[-1])
        expect(helper.next_step).to be_nil
      end
    end
  end

  describe "#previous_step" do
    context "when complete" do
      it "alway return the last step" do
        issue = ReportIssue.new(reporting_as: "business", completed_steps: ORG_STEPS)
        assign(:step_model, issue)
        assign(:step, ORG_STEPS[4])
        expect(helper.previous_step).to eq ORG_STEPS[-1]
      end
    end

    context "when not complete" do
      it "alway return the previous step if there is one" do
        issue = ReportIssue.new(reporting_as: "business", completed_steps: %w[contact_details].freeze)
        assign(:step_model, issue)
        assign(:step, ORG_STEPS[4])
        expect(helper.previous_step).to eq ORG_STEPS[3]
      end

      it "return nil if no step" do
        issue = ReportIssue.new(reporting_as: "business", completed_steps: %w[contact_details].freeze)
        assign(:step_model, issue)
        assign(:step, ORG_STEPS[0])
        expect(helper.previous_step).to be_nil
      end
    end
  end
end
