require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    DatabaseCleaner.clean
    @password = "123456"
    @user = create :user, password: @password, password_confirmation: @password
  end

  def test_must_get_new_on_login
    get login_url

    assert_kind_of User, assigns(:user)
    assert_response :success
  end

  def test_must_login_user_on_sessions_create
    post sessions_url, params: {session: {email: @user.email, password: @password}}

    assert_redirected_to root_url
  end

  def test_must_not_login_user_on_sessions_create_when_email_is_invalid
    post sessions_url, params: {session: {email: "test@sample.com", password: @password}}

    assert_template :new
    assert_response :success
  end

  def test_must_not_login_user_on_sessions_create_when_password_is_invalid
    post sessions_url, params: {session: {email: @user.email, password: "test"}}

    assert_template :new
    assert_response :success
  end

  def test_must_logout_current_user_on_sessions_destroy
    sign_in(@user)
    delete logout_url

    assert_redirected_to login_url
  end

  def test_must_redirect_to_login_page_on_destroy_when_user_not_logged_in
    delete logout_url

    assert_redirected_to login_url
  end
end
