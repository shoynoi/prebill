# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of :name }
  subject { create(:user) }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of :email }
  it { is_expected.to validate_length_of(:password).is_at_least(6) }
  it { is_expected.to validate_confirmation_of :password }

  it "is valid user" do
    user = User.new(name: "tester", email: "tester@example.com", password: "secret", password_confirmation: "secret")
    expect(user).to be_valid
  end
end
