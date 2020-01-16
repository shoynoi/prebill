# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :require_login

  private
    def not_authenticated
      redirect_to root_path, alert: "ログインしてください。"
    end
end
