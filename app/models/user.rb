class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, email: true
  validates :password, confirmation: true, length: {minimum: 6}
  validates :password_confirmation, presence: true, if: 'password.present?'
end
