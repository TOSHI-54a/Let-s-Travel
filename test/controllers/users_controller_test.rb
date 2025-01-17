# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should get new' do
    get users_new_url
    assert_response :success
  end

  test 'should get create' do
    get users_create_url
    assert_response :success
  end

  test 'should get edit' do
    get users_edit_url
    assert_response :success
  end

  test 'should get update' do
    get users_update_url
    assert_response :success
  end

  test 'should get destroy' do
    get users_destroy_url
    assert_response :success
  end
end
