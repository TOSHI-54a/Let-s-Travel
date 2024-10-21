class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :set_user, only: %i[edit update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, success: 'ユーザー登録が完了しました'
    else
      flash.now[:danger] ='ユーザー登録に失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit; end

  def update
    if @user.update(edit_params)
      redirect_to user_path, flash: { success: "ユーザー情報を更新しました"}
    else
      flash.now[:danger]= "ユーザー情報を更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def edit_params
    params.require(:user).permit(:name, :email, :avatar)
  end

  def set_user
    @user = User.find(current_user.id)
  end
end
