class User < ApplicationRecord
  authenticates_with_sorcery!

  validates :password, length: { minimum: 6 }, confirmation: true, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?

  validates :email, uniqueness: true
  validates :name, presence: true

  private
    def password_required?
      new_record? || password.present?
    end
end
