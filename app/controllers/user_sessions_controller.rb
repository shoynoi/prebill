class UserSessionsController < ApplicationController
  layout "welcome"
  skip_before_action :require_login, except: :destroy

  def new
    @user = User.new
  end

  def create
    @user = login(params[:user][:email], params[:user][:password], params[:remember])

    if @user
      redirect_back_or_to root_path, notice: "ログインしました。"
    else
      @user = User.new(email: params[:user][:email], password: params[:user][:password])
      flash.now[:alert] = "メールアドレスかパスワードが正しくありません。"
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "ログアウトしました。"
  end
end
