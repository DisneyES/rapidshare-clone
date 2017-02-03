class Upload < ApplicationRecord
  BLACKLISTED_EXTENSIONS = ["js"]

  mount_uploader :file, AssetUploader

  has_secure_token :access_token

  belongs_to :user
  validates :file, presence: true
  validates :access_token, presence: true, uniqueness: true, on: :update

  def exported_name
    fname = self.file.file.filename
    extn = File.extname(fname)
    extn.slice!(0)
    BLACKLISTED_EXTENSIONS.include?(extn) ? "#{fname}.txt" : fname
  end
end
