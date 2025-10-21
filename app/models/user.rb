class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  validates_uniqueness_of :user_name, case_sensitive: false
  validates_uniqueness_of :email_address, case_sensitive: false, allow_nil: true
  validates_presence_of :user_name

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end
