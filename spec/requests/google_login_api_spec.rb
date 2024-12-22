# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GoogleLoginApis', type: :request do
  describe 'GET /callback' do
    it 'returns http success' do
      pending '実装予定であるが、未着手'
      post '/google_login_api/callback'
      expect(response).to have_http_status(:success)
    end
  end
end
