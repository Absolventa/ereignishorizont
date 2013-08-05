class User < ActiveRecord::Base
  has_secure_password
  validates_uniqueness_of :email
  validates :password, length: 8..20

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create },
                              presence: true
end
