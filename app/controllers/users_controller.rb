# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :require_login, only: %i(new create activate)

  def new
    @user = User.new
    render layout: "welcome"
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "アカウントを作成しました！メールアドレスを確認してアカウントを有効化してください。"
    else
      render :new, layout: "welcome"
    end
  end

  def activate
    if @user = User.load_from_activation_token(params[:id])
      @user.activate!
      auto_login(@user)
      redirect_to root_path, notice: "メールアドレスの確認が完了しました！"
    else
      not_authenticated
    end
  end

  private
    def user_params
      params.require(:user).permit(
        :name,
        :email,
        :password,
        :password_confirmation,
        )
    end
end
