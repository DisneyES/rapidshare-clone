class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, email: true
  validates :password, confirmation: true, length: {minimum: 6}, on: :create
  validates :password_confirmation, presence: true, if: 'password.present?'

  has_many :uploads, dependent: :destroy

  before_validation do
    self.email&.downcase!
  end
end
