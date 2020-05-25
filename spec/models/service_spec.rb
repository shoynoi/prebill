# frozen_string_literal: true

require "rails_helper"

RSpec.describe Service, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :plan }
  it { is_expected.to validate_numericality_of(:price) }

  describe "#remind" do
    let(:remind_yesterday) { create(:service, :remind_yesterday) }
    let(:remind_today) { create(:service, :remind_today) }
    let(:remind_tomorrow) { create(:service, :remind_tomorrow) }

    context "when service is found" do
      it "returns services that remind_on is today" do
        expect(Service.remind).to contain_exactly(remind_today)
        expect(Service.remind).to_not contain_exactly(remind_yesterday, remind_tomorrow)
      end
    end

    context "when service is not found" do
      it "returns an empty collection" do
        travel_to(Time.zone.parse("2020-04-01")) do
          expect(Service.remind).to be_empty
        end
      end
    end
  end

  describe "#renewal" do
    let!(:renewal_yesterday) { create(:service, :renewal_yesterday) }
    let!(:renewal_today) { create(:service, :renewal_today) }
    let!(:renewal_tomorrow) { create(:service, :renewal_tomorrow) }

    context "when service is found" do
      it "returns services that renewed_on is today" do
        expect(Service.renewal).to contain_exactly(renewal_today)
        expect(Service.renewal).to_not contain_exactly(renewal_yesterday, renewal_tomorrow)
      end
    end

    context "when service is not found" do
      it "returns an empty collection" do
        travel_to(Time.zone.parse("2020-04-01")) do
          expect(Service.renewal).to be_empty
        end
      end
    end
  end

  describe "annual_total_amount" do
    let(:user) { create(:user) }

    context "when service has a price" do
      let!(:monthly_service) { create(:service, price: 1000, user: user) }
      let!(:yearly_service) { create(:service, :plan_yearly, price: 2000, user: user) }

      it "returns annual total amount" do
        expect(user.services.annual_total_amount).to eq 14000
      end
    end

    context "when service has not price" do
      let!(:monthly_service) { create(:service, plan: 0, price: nil, user: user) }
      let!(:yearly_service) { create(:service, plan: 1, price: nil, user: user) }

      it "return 0" do
        expect(user.services.annual_total_amount).to eq 0
      end
    end
  end

  describe "monthly_average_amount" do
    let(:user) { create(:user) }

    context "when service has a price" do
      let!(:monthly_service) { create(:service, price: 1000, user: user) }
      let!(:yearly_service) { create(:service, :plan_yearly, price: 2000, user: user) }

      it "returns monthly average amount" do
        expect(user.services.monthly_average_amount).to eq 1166
      end
    end

    context "when service has not price" do
      let!(:monthly_service) { create(:service, plan: 0, price: nil, user: user) }
      let!(:yearly_service) { create(:service, plan: 1, price: nil, user: user) }

      it "returns 0" do
        expect(user.services.monthly_average_amount).to eq 0
      end
    end
  end

  describe "#next_renewed_on" do
    let(:user) { create(:user) }

    context "when plan is monthly" do
      let(:service) { create(:service, plan: 0, renewed_on: Time.zone.parse("2021-01-31"), user: user) }

      it "returns next monthly renewal date" do
        travel_to(Time.zone.parse("2021-02-01")) do
          expect(service.next_renewed_on).to eq Date.parse("2021-02-28")
        end
        travel_to(Time.zone.parse("2021-03-01")) do
          expect(service.next_renewed_on).to eq Date.parse("2021-03-31")
        end
      end
    end

    context "when plan is yearly" do
      let(:service) { create(:service, plan: 1, renewed_on: Time.zone.parse("2020-02-29"), user: user) }

      it "returns next yearly renewal date" do
        travel_to(Time.zone.parse("2020-03-01")) do
          expect(service.next_renewed_on).to eq Date.parse("2021-02-28")
        end
      end
    end
  end
end
