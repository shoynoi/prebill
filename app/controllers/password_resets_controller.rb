# frozen_string_literal: true

class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  def new
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_reset_password_instructions!
      redirect_to login_path, notice: "パスワード再設定用のメールを送信しました。"
    else
      flash.now[:alert] = "メールアドレスが正しくありません。"
      render :new
    end
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    if @user.blank?
      not_authenticated
    end
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    if @user.blank?
      not_authenticated
      return
    end

    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password(params[:user][:password])
      redirect_to(root_path, notice: "パスワードの再設定が完了しました。")
    else
      render :edit
    end
  end
end
