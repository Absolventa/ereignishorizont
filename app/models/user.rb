class User < ActiveRecord::Base
  has_secure_password
  validates_uniqueness_of :email
  validates :password, length: 8..20
	validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create },
                              presence: true

  before_create { generate_token(:auth_token) }

 	def generate_token(column)
 		begin
			self[column] = SecureRandom.urlsafe_base64
		end while User.exists?(column => self[column])
	end                        
end
