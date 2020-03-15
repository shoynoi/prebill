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
    User.load_from_activation_token(params[:id]) do |user, failure|
      if user && !failure
        user.activate!
        auto_login(user)
        redirect_to root_path, notice: "メールアドレスの確認が完了しました！"
      else
        case failure
        when :invalid_token, :user_not_found
          flash[:alert] = "不正なトークンです"
        when :token_expired
          flash[:alert] = "トークンの有効期限が切れています"
        end
        redirect_to root_path
      end
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
