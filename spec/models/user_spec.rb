require 'rails_helper'

RSpec.describe User, type: :model do
    it '名前がないと無効であること' do
        user = User.new(name: nil)
        expect(user).not_to be_valid
    end
end