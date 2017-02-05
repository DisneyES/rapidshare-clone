class Upload < ApplicationRecord
  BLACKLISTED_EXTENSIONS = ["js"]

  mount_uploader :file, AssetUploader

  has_secure_token :access_token

  belongs_to :user
  validates :file, presence: true
  validates :access_token, presence: true, uniqueness: true, on: :update

  def filename
    self.file.file.filename
  end

  def content_type
    self.file.file.content_type
  end

  def exported_name
    fname = filename
    extn = File.extname(fname)
    extn.slice!(0)
    BLACKLISTED_EXTENSIONS.include?(extn) ? "#{fname}.txt" : fname
  end
end
