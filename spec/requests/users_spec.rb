require 'rails_helper'

RSpec.describe 'Users API', type: :request do
    let(:user) { create(:user) }
    describe 'GET /users' do

        it 'ユーザー情報にアクセスできること' do
            login_user(user, "password")
            get "/users/#{user.id}"
            expect(response).to have_http_status(:ok)
        end
    end
end