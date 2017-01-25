require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def test_must_get_new_on_signup
    get new_user_url

    assert_kind_of User, assigns(:user)
    assert_response :success
  end

  def test_must_create_user_and_login_on_create
    assert_difference 'User.count' do
      post users_url, params: {user: attributes_for(:user, :with_password)}
    end

    assert_kind_of User, assigns(:user)
    assert_redirected_to root_url
  end

  def test_must_set_user_attributes_on_create
    attrs = attributes_for(:user, :with_password)
    post users_url, params: {user: attrs}

    user = assigns(:user)
    assert_equal attrs[:name], user.name
    assert_equal attrs[:email], user.email
    assert_equal attrs[:password], user.password
    assert_not_nil user.password_digest

    assert_redirected_to root_url
  end

  def test_must_not_create_user_when_params_invalid
    assert_no_difference 'User.count' do
      attrs = attributes_for(:user)
      post users_url, params: {user: attrs}
    end

    assert_template :new
    assert_response :success
  end
end

