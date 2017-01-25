require 'test_helper'

class UploadTest < ActiveSupport::TestCase
  def setup
    DatabaseCleaner.clean
    @user = create :user, :with_password
    @upload = build :upload, :with_file, user: @user
  end

  def test_upload_is_invalid_if_file_is_empty
    upload = build :upload, user: @user

    assert_equal false, upload.valid?
    assert_equal ["can't be blank"], upload.errors[:file]
  end

  def test_upload_is_invalid_if_access_token_is_empty_on_update
    @upload.save
    @upload.access_token = nil

    assert_equal false, @upload.valid?
    assert_equal ["can't be blank"], @upload.errors[:access_token]
  end

  def test_upload_is_valid
    assert_equal true, @upload.save
  end
end

