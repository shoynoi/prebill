# frozen_string_literal: true

class PresetService < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
