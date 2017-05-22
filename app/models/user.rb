class User < ApplicationRecord

  has_secure_password

  # validations
  #
  #

  validates :password, length: { minimum: 5 }, if: lambda { |m| m.password.present? }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create },
                              presence: true, uniqueness: true

  # callbacks
  #
  #

  before_create { generate_token(:auth_token) }

  # instance methods
  #
  #

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.now.utc
    save!(validate: false)
    UserMailer.password_reset(self).deliver_later
  end

end
