# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let!(:user) { create(:user, :activated, email: "tester@example.com") }

  describe "reset_password_email" do
    let(:mail) { UserMailer.reset_password_email(user) }

    before do
      user.generate_reset_password_token!
    end

    it "sends a email successfully" do
      expect {
        mail.deliver_now
      }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it "sends a password reset email to user's email address" do
      expect(mail.to). to eq ["tester@example.com"]
    end

    it "sends from support email address" do
      expect(mail.from). to eq ["info@prebill.me"]
    end

    it "sends with the correct subject" do
      expect(mail.subject). to eq "PreBill パスワードのリセット"
    end

    context "text part" do
      it "sends a message with a password reset token" do
        password_reset_url = "#{ActionMailer::Base.default_url_options[:host]}:#{ActionMailer::Base.default_url_options[:port]}/password_resets/#{user.reset_password_token}/edit"

        expect(mail.text_part.body.to_s).to match %r(こんにちは、#{user.name}さん。)
        expect(mail.text_part.body.to_s).to match %r(#{password_reset_url})
      end
    end

    context "html part" do
      it "sends a message with a password reset token" do
        password_reset_url = "#{ActionMailer::Base.default_url_options[:host]}:#{ActionMailer::Base.default_url_options[:port]}/password_resets/#{user.reset_password_token}/edit"

        expect(mail.html_part.body.to_s).to match %r(こんにちは、#{user.name}さん。)
        expect(mail.html_part.body.to_s).to match %r(#{password_reset_url})
      end
    end
  end

  describe "renew_service" do
    let(:services) { create_list(:service, 1, :renewal_today, user: user) }
    let(:mail) { UserMailer.renew_service(user, services) }

    it "sends a email successfully" do
      expect {
        mail.deliver_now
      }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it "sends a renew services email to user's email address" do
      expect(mail.to). to eq ["tester@example.com"]
    end

    it "sends from support email address" do
      expect(mail.from). to eq ["info@prebill.me"]
    end

    it "sends with the correct subject" do
      expect(mail.subject). to eq "PreBill 登録されたサービスが更新されました。"
    end

    context "text part" do
      it "sends a message with a renewal services list" do
        expect(mail.text_part.body.to_s).to match %r(こんにちは、#{user.name}さん。\r\n本日更新日を迎えたサービスをお知らせいたします。)
        expect(mail.text_part.body.to_s).to match %r(#{services.first.name})
      end
    end

    context "html part" do
      it "sends a message with a renewal services list" do
        expect(mail.html_part.body.to_s).to match %r(こんにちは、#{user.name}さん。本日更新日を迎えたサービスをお知らせいたします。)
        expect(mail.html_part.body.to_s).to match %r(#{services.first.name})
      end
    end
  end

  describe "remind_service" do
    let(:services) { create_list(:service, 1, :renewal_tomorrow, :remind_today, user: user) }
    let(:mail) { UserMailer.remind_services(user, services) }

    it "sends a email successfully" do
      expect {
        mail.deliver_now
      }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it "sends a remind services email to user's email address" do
      expect(mail.to). to eq ["tester@example.com"]
    end

    it "sends from support email address" do
      expect(mail.from). to eq ["info@prebill.me"]
    end

    it "sends with the correct subject" do
      expect(mail.subject). to eq "PreBill サービス更新のリマインド"
    end

    context "text part" do
      it "sends a message with a remind services list" do
        expect(mail.text_part.body.to_s).to match %r(こんにちは、#{user.name}さん。\r\n登録されているサブスクリプションがもうすぐ更新されます。)
        expect(mail.text_part.body.to_s).to match %r(#{services.first.name})
      end
    end

    context "html part" do
      it "sends a message with a renewal services list" do
        expect(mail.html_part.body.to_s).to match %r(こんにちは、#{user.name}さん。登録されているサブスクリプションがもうすぐ更新されます。)
        expect(mail.html_part.body.to_s).to match %r(#{services.first.name})
      end
    end
  end

  describe "activation_needed_email" do
    let!(:inactivated_user) { create(:user, :inactivated, email: "inactivated@example.com") }
    let(:mail) { UserMailer.activation_needed_email(inactivated_user) }

    before do
      inactivated_user.setup_activation
    end

    it "sends a email successfully" do
      expect {
        mail.deliver_now
      }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it "sends a activation email to user's email address" do
      expect(mail.to). to eq ["inactivated@example.com"]
    end

    it "sends from support email address" do
      expect(mail.from). to eq ["info@prebill.me"]
    end

    it "sends with the correct subject" do
      expect(mail.subject). to eq "PreBill メールアドレスの確認"
    end

    context "text part" do
      it "sends a message with an activation url" do
        activation_url = "#{ActionMailer::Base.default_url_options[:host]}:#{ActionMailer::Base.default_url_options[:port]}/users/#{inactivated_user.activation_token}/activate"

        expect(mail.text_part.body.to_s).to match "PreBillへ会員登録していただき、ありがとうございます。"
        expect(mail.text_part.body.to_s).to match %r(#{activation_url})
      end
    end

    context "html part" do
      it "sends a message with an activation url" do
        activation_url = "#{ActionMailer::Base.default_url_options[:host]}:#{ActionMailer::Base.default_url_options[:port]}/users/#{inactivated_user.activation_token}/activate"

        expect(mail.html_part.body.to_s).to match "PreBillへ会員登録していただき、ありがとうございます。"
        expect(mail.html_part.body.to_s).to match %r(#{activation_url})
      end
    end
  end
end
