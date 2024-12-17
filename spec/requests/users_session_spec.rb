# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User', type: :request do
  describe 'GET /users' do
    let(:user) { create(:user) }

    it 'ログイン画面の表示に成功すること' do
      get login_path
      expect(response).to have_http_status(:ok)
    end

    it 'ログインに成功すること' do
      login_user(user, 'password')
      expect(response).to redirect_to root_path
    end

    it 'ユーザー情報へアクセスできること' do
      login_user(user, 'password')
      get "/users/#{user.id}"
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'build_userで' do
    let(:user) { build(:user) }
    it 'ログインに失敗すること' do
      login_user(user, 'password')
      expect(response.body).to include 'ログインに失敗しました'
    end
  end

  describe 'logout' do
    let(:user) { create(:user) }
    it 'ログアウトできること' do
      login_user(user, 'password')
      delete logout_path
      expect(session[:user_id]).to be_nil
    end
  end
end
