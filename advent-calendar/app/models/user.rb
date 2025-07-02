class User < ApplicationRecord
  has_secure_password

  has_many :answers, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :password_digest, presence: true
end
