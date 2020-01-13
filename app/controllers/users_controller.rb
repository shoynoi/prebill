class UsersController < ApplicationController
  skip_before_action :require_login, only: %i(new create)

  def new
    @user = User.new
    render layout: "welcome"
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "ユーザー「#{@user.name}」を登録しました"
    else
      render :new, layout: "welcome"
    end
  end

  def edit
    @user = current_user
  end

  def update
    if current_user.update(user_params)
      redirect_to root_path, notice: "ユーザー情報を変更しました。"
    else
      render :edit
    end
  end

  def destroy
    current_user.destroy
    redirect_to root_path, notice: "退会が完了しました。"
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
