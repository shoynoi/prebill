# frozen_string_literal: true

require "rails_helper"

RSpec.describe ServiceDecorator, type: :decorator do
  before do
    ActiveDecorator::Decorator.instance.decorate(service)
  end

  describe "#formatted_remind_on" do
    context "when remind_on equal to current year" do
      let(:service) { create(:service, remind_on: Date.parse("2020-05-25")) }

      it "displays remind date in short format" do
        travel_to Date.parse("2020-05-25") do
          expect(service.formatted_remind_on).to eq "5月25日"
        end
      end
    end

    context "when remind_on unequal to current year" do
      let(:service) { create(:service, remind_on: Date.parse("2021-05-25")) }

      it "displays remind date in short format" do
        travel_to Date.parse("2020-05-25") do
          expect(service.formatted_remind_on).to eq "2021年05月25日"
        end
      end
    end
  end

  describe "#formatted_renewed_on" do
    context "when renewed_on equal to current year" do
      let(:service) { create(:service, renewed_on: Date.parse("2020-05-25")) }

      it "displays renewal date in short format" do
        travel_to Date.parse("2020-05-25") do
          expect(service.formatted_renewed_on).to eq "5月25日"
        end
      end
    end

    context "when renewed_on unequal to current year" do
      let(:service) { create(:service, renewed_on: Date.parse("2021-05-25")) }

      it "displays renewal date in short format" do
        travel_to Date.parse("2020-05-25") do
          expect(service.formatted_renewed_on).to eq "2021年05月25日"
        end
      end
    end
  end
end
