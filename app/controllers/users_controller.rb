class UsersController < ApplicationController
  skip_before_action :require_login, only: %i(new create)

  def new
    @user = User.new
    render layout: "welcome"
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "アカウントを作成しました。"
    else
      render :new, layout: "welcome"
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
