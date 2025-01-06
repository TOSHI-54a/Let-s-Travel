# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User', type: :request do
  before(:all) do
    # テスト環境で CSRF トークンを無効化、これがないと422errorとなる（テストではauthenticationが含まれていないため）
    ActionController::Base.allow_forgery_protection = false
  end

  after(:all) do
    # テスト終了後に CSRF トークンを有効化
    ActionController::Base.allow_forgery_protection = true
  end

  describe 'ログイン画面の表示' do
    it 'ログイン画面が正常に表示されること' do
      get login_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'ユーザーのログインとアクセス' do
    let(:user) { create(:user) }

    context 'ログインに成功する場合' do
      before do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      end

      it 'リダイレクト後にユーザー情報にアクセスできること' do
        get "/users/#{user.id}"
        expect(response).to have_http_status(:ok)
      end
    end

    context '無効なユーザーでのログイン' do
      let(:invalid_user) { build(:user) }

      it 'ログインに失敗すること' do
        post login_path, params: { email: invalid_user.email, password: 'wrong_password' }
        expect(response.body).to include('ログインに失敗しました')
      end
    end
  end

  describe 'ログアウト機能' do
    let(:user) { create(:user) }

    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      delete logout_path
    end

    it 'セッションが破棄され、適切なステータスが返されること' do
      expect(request.session[:user_id]).to be_nil
      expect(response).to have_http_status(:see_other)
    end
  end
end
