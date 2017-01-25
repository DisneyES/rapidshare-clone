require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = build :user
  end

  def test_user_is_invalid_if_email_is_empty
    @user.email = nil
    assert_equal false, @user.valid?
    assert_equal ["can't be blank", "is not a valid email address"], @user.errors[:email]
  end

  def test_user_is_invalid_if_email_is_invalid
    @user.email = "aditya"
    assert_equal false, @user.valid?
    assert_equal ["is not a valid email address"], @user.errors[:email]
  end

  def test_user_is_invalid_if_password_is_empty
    assert_equal false, @user.valid?
    assert_equal ["can't be blank", "is too short (minimum is 6 characters)"], @user.errors[:password]
  end

  def test_user_is_invalid_if_password_is_invalid
    @user.password = "123"
    assert_equal false, @user.valid?
    assert_equal ["is too short (minimum is 6 characters)"], @user.errors[:password]
  end

  def test_user_is_invalid_if_password_confirmation_is_empty
    @user.password = "123456"
    assert_equal false, @user.valid?
    assert_equal ["can't be blank"], @user.errors[:password_confirmation]
  end

  def test_user_is_invalid_if_password_confirmation_is_invalid
    @user.password = "123456"
    @user.password_confirmation = "123"
    assert_equal false, @user.valid?
    assert_equal ["doesn't match Password"], @user.errors[:password_confirmation]
  end

  def test_user_is_valid
    @user = build :user, :with_password
    assert_equal true, @user.valid?
  end
end
