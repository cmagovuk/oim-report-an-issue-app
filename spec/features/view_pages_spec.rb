require "rails_helper"

RSpec.feature "View pages", type: :feature do
  context "when no maintenance" do
    before do
      allow(Rails.application.config.x).to receive(:maintenance_text).and_return("")
    end
    describe "Home page" do
      it "Navigate to home" do
        visit "/"
        expect(page).to have_text("Report")
      end
    end

    describe "Start a new issue" do
      it "click start" do
        visit "/"

        click_link "Continue"
        expect(page).to have_text("Name and contact")
      end
    end
  end

  context "when maintenance" do
    before do
      allow(Rails.application.config.x).to receive(:maintenance_text).and_return("Maintenance")
    end
    describe "Home page" do
      it "Navigate to home" do
        visit "/"
        expect(page).to have_text("Maintenance")
      end
    end
  end
end
