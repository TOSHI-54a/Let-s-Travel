# frozen_string_literal: true

class GoogleLoginApiController < ApplicationController
  require 'googleauth/id_tokens/verifier'

  skip_before_action :require_login
  protect_from_forgery except: :callback
  before_action :verify_g_csrf_token

  def callback
    payload = Google::Auth::IDTokens.verify_oidc(params[:credential], aud: '802231099292-dgt2tmi7g2haiutjqk6g445vtpuqtf2e.apps.googleusercontent.com')
    user = User.find_or_initialize_by(email: payload['email'])
    if user.new_record?
      user.name = payload['name']
      random_password = SecureRandom.hex(16) # 必須フィールドを埋める
      user.password = random_password
      user.password_confirmation = random_password
      user.salt = SecureRandom.hex(8) # 必須フィールドを埋める
      if user.save
        Rails.logger.info("User created successfully: #{user.inspect}")
      else
        Rails.logger.error("Failed to create user: #{user.errors.full_messages}")
        redirect_to root_path, alert: 'ユーザー作成に失敗しました' and return
      end
    else
      Rails.logger.info("User found: #{user.inspect}")
    end
    session[:user_id] = user.id
    redirect_to root_path, success: 'ログインしました'
  end

  private

  def verify_g_csrf_token
    return unless cookies['g_csrf_token'].blank? || params[:g_csrf_token].blank? || cookies['g_csrf_token'] != params[:g_csrf_token]

    flash.now[:danger] = '不正なアクセスです'
    redirect_to new_user_session_path, notice: '失敗'
  end
end
