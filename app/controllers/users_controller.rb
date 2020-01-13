class UsersController < ApplicationController
  layout "welcome"

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "ユーザー「#{@user.name}」を登録しました"
    else
      render :new
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
