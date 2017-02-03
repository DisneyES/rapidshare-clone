class Upload < ApplicationRecord
  BLACKLISTED_EXTENSIONS = ["js"]

  attr_accessor :uploaded_file

  has_secure_token :access_token

  belongs_to :user

  validates :file, :content_type, presence: true
  validates :access_token, presence: true, uniqueness: true, on: :update

  validate do
    self.errors.add(:file, "upload must be present.") unless uploaded_file.present?
  end

  after_save :persist_file
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

  def exported_name
    extn = File.extname(file)
    extn.slice!(0)
    BLACKLISTED_EXTENSIONS.include?(extn) ? "#{file}.txt" : file
  end

  private

  def storage_url
    "uploads/#{self.class.to_s.underscore}/file/#{self.id}"
  end

  def persist_file
    FileUtils.mkdir_p(storage_path) unless Dir.exist?(storage_path)
    File.open(file_path, 'wb') {|f| f.write(uploaded_file.read) }
  end

  def remove_file
    File.delete(file_path) if File.exist?(file_path)
  end
end
