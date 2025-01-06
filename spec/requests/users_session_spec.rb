# frozen_string_literal: true

require 'rails_helper'

# 失敗する原因が不明なので全体をskip
RSpec.describe 'User', type: :request do

  describe 'GET /users' do
    it 'ログイン画面の表示に成功すること' do
      get login_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /users' do
    let(:user) { create(:user) }

    before do
      puts "User email: #{user.email}, User password: #{user.crypted_password}"
      expect(user.valid_password?('password')).to be true
      post login_path, params: { email: user.email, password: "password" }
      puts response.body.lines.first(50).join("\n")
      puts response.status
      # expect(response).to have_http_status(:found)
    end

    it 'ログインに成功すること' do
      login_user(user, 'password')
      expect(response).to redirect_to root_path
    end

    it 'ユーザー情報へアクセスできること' do
      # login_user(user, 'password')
      get "/users/#{user.id}"
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'build_userで' do
    let(:user) { build(:user) }
    it 'ログインに失敗すること' do
      post login_path, params: { email: user.email, password: "password" }
      expect(response.body).to include 'ログインに失敗しました'
    end
  end

  describe 'logout' do
    let(:user) { create(:user) }
    it 'ログアウトできること' do
      delete logout_path
      expect(session[:user_id]).to be_nil
    end
  end
end
