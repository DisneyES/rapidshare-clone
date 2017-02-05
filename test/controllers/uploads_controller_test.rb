require 'test_helper'

class UploadsControllerTest < ActionDispatch::IntegrationTest
  setup do
    DatabaseCleaner.clean
    @user = create :user, :with_password
    @upload = create :upload, :with_file, user: @user
  end

  def test_must_get_current_user_uploaded_files_on_index
    sign_in(@user)

    get uploads_url

    assert_equal [@upload], assigns(:uploads)
    assert_response :success
  end

  def test_must_not_get_other_user_uploaded_files_on_index
    another_upload = build :upload, :with_file, user: create(:user, :with_password)
    sign_in(@user)

    get uploads_url

    assert_equal [@upload], assigns(:uploads)
    assert_response :success
  end

  def test_must_upload_file_on_create
    filename = "sample.png"
    file = Rack::Test::UploadedFile.new("test/fixtures/#{filename}", "image/png")
    sign_in(@user)

    assert_difference 'Upload.count' do
      post uploads_url, params: {upload: {file: file}}
    end

    new_upload = assigns(:upload)
    assert_equal filename, new_upload.file

    assert_redirected_to uploads_url
  end

  def test_must_not_upload_invalid_file_on_create
    filename = "sample.png"
    sign_in(@user)

    assert_no_difference 'Upload.count' do
      post uploads_url, params: {upload: {file: nil}}
    end

    assert_redirected_to uploads_url
  end

  def test_must_remove_file_on_destroy
    sign_in(@user)

    assert_difference 'Upload.count', -1 do
      delete upload_url(@upload)
    end
    assert_redirected_to uploads_url
  end

  def test_must_not_remove_another_users_file_on_destroy
    another_user = create(:user, :with_password)
    sign_in(another_user)

    assert_no_difference 'Upload.count', -1 do
      delete upload_url(@upload)
    end
    assert_redirected_to uploads_url
  end

  def test_must_download_file
    sign_in(@user)

    get download_uploaded_file_url(@upload.access_token, @upload.filename)
    assert_response :success
  end
end
