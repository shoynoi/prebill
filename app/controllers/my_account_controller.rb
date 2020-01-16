# frozen_string_literal: true

class MyAccountController < ApplicationController
  before_action :set_user
  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to root_path, notice: "ユーザー情報を変更しました。"
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to root_path, notice: "退会が完了しました。"
  end

  def close
  end

  private
    def set_user
      @user = current_user
    end

    def user_params
      params.require(:user).permit(
        :name,
        :email,
        :password,
        :password_confirmation,
        )
    end
end
