class UserSessionsController < ApplicationController
  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_back_or_to root_path, notice: "ログインしました。"
    else
      flash.now[:alert] = "ユーザー名かパスワードが正しくありません。"
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "ログアウトしました。"
  end
end
