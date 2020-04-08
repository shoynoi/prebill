# frozen_string_literal: true

class UserSessionsController < ApplicationController
  layout "welcome"
  skip_before_action :require_login, except: :destroy

  def new
    @user = User.new
  end

  def create
    login(params[:user][:email], params[:user][:password], params[:remember]) do |user, failure|
      if user && !failure
        redirect_back_or_to root_path, notice: "ログインしました。"
      else
        case failure
        when :invalid_login, :invalid_password
          @user = User.new(email: params[:user][:email], password: params[:user][:password])
          flash.now[:alert] = "メールアドレスかパスワードが正しくありません。"
        when :inactive
          flash.now[:alert] = "メールを確認して、アカウントを有効化してください。"
        end
        render :new
      end
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "ログアウトしました。"
  end
end
