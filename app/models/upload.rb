class Upload < ApplicationRecord
  mount_uploader :file, AssetUploader

  has_secure_token :access_token

  belongs_to :user
  validates :file, presence: true
  validates :access_token, presence: true, uniqueness: true, on: :update
end
