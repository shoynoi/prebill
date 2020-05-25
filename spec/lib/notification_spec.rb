# frozen_string_literal: true

require "rake_helper"
require "rails_helper"

describe "notification" do
  describe "notification:renewal" do
    let(:task) { Rake.application["notification:renewal"] }

    describe "notify user to renewed service" do
      let!(:renewed_service) { create(:service, :renewal_today, user: user) }

      context "notification in app" do
        let(:user) { create(:user, :activated) }

        it "create notification" do
          expect { task.invoke }.to change { Notification.count }.by(1)
        end
      end

      context "when a user have set up to receive email" do
        let(:user) { create(:user, :activated, :accept_to_receive) }

        it "sends a renewal mail" do
          expect { task.invoke }.to change { ActionMailer::Base.deliveries.count }.by(1)
        end
      end

      context "when a user have not set up to receive email" do
        let(:user) { create(:user, :activated, :reject_to_receive) }

        it "does not send a renewal mail" do
          expect { task.invoke }.to_not change { ActionMailer::Base.deliveries.count }
        end
      end
    end
  end

  describe "notification:remind" do
    let(:task) { Rake.application["notification:remind"] }
    let(:user) { create(:user, :activated) }

    context "when a service has renewed_on" do
      let!(:remind_service) { create(:service, :renewal_tomorrow, :remind_today, user: user) }
      it "sends an email to remind service" do
        expect { task.invoke }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context "when a service's renewed_on is nil" do # FIXME
      let!(:remind_service) { create(:service, :remind_today, user: user, renewed_on: nil) }
      it "has an error" do
        expect { task.invoke }.to raise_error ActionView::Template::Error
      end
    end
  end
end
