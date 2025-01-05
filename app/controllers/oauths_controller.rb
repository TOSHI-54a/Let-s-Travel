# frozen_string_literal: true

class OauthsController < ApplicationController
  skip_before_action :require_login

  def oauth
    Rails.logger.info "Starting OAuth for provider: #{auth_params[:provider]}"
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]

    # 既存のユーザーをプロバイダ情報を元に検索し、存在すればログイン
    if (@user = login_from(provider))
      redirect_to root_path, notice: "#{provider.titleize}アカウントでログインしました"
    else
      begin
        signup_and_login(provider)
        redirect_to root_path, notice: "#{provider.titleize}アカウントでログインしました"
      rescue ActiveRecord::RecordInvalid => e
        if e.message.include?('email')
          redirect_to login_path, alert: 'このメールアドレスは既に登録されています。ログインしてください。'
        else
          Rails.logger.error "OAuth signup error: #{e.message}"
          redirect_to root_path, alert: 'アカウント作成中に問題が発生しました。もう一度お試しください。'
        end
      rescue StandardError => e
        Rails.logger.error "Unexpected OAuth error: #{e.message}"
        redirect_to root_path, alert: '予期しないエラーが発生しました。サポートにお問い合わせください。'
      end
    end
  end

  private

  def auth_params
    params.permit(:provider, :code, :scope, :authuser, :prompt)
  end

  def signup_and_login(provider)
    # プロバイダーからの情報で新規ユーザーを作成
    @user = create_from(provider)

    # セッションをリセットし、自動ログイン
    reset_session
    auto_login(@user)
  end
end
