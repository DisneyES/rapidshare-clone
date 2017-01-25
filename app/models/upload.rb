class Upload < ApplicationRecord
  mount_uploader :file, AssetUploader

  has_secure_token :access_token

  belongs_to :user
  validates :file, :access_token, presence: true
  validates :access_token, uniqueness: true
end
