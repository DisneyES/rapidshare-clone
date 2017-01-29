class Upload < ApplicationRecord
  has_secure_token :access_token

  belongs_to :user

  validates :file, :content_type, presence: true
  validates :access_token, presence: true, uniqueness: true, on: :update

  after_destroy :remove_file

  def file_url
    '/' + storage_url + '/' + file
  end

  def file_path
    storage_path + file
  end

  def storage_path
    Rails.root.join("public", storage_url)
  end

  def file?
    file.presence && File.exist?(file_path)
  end

  private

  def storage_url
    "uploads/#{self.class.to_s.underscore}/file/#{self.id}"
  end

  def remove_file
    File.delete(file_path) if File.exist?(file_path)
  end
end
