# frozen_string_literal: true

class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :services, dependent: :destroy

  validates :password, length: { minimum: 6 }, confirmation: true, if: :password_required?
  validates :email, uniqueness: true, presence: true
  validates :name, presence: true

  private
    def password_required?
      new_record? || password.present?
    end
end
