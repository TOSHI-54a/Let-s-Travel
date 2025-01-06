# frozen_string_literal: true

class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  skip_before_action :verify_authenticity_token, if: -> { Rails.env.test? }

  def new
    @user = User.new
  end

  def create
    Rails.logger.info "Params: #{params.inspect}"
    login_params = params.permit(:email, :password, :authenticity_token, :commit)
    @user = login(login_params[:email], login_params[:password])
    if @user
      Rails.logger.info "Login successful for user: #{@user.email}"
      redirect_to root_path, success: 'ログインしました'
    else
      flash.now[:danger] = 'ログインに失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, status: :see_other, success: 'ログアウトしました'
  end
end
