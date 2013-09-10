class RemoteSide < ActiveRecord::Base

  validates :name, presence: true, format: { with: /\A[a-z0-9\s]+\Z/i }
  validates_uniqueness_of :name
  before_create :generate_api_token
  has_many :incoming_event

  private

  def generate_api_token
    begin
      self.api_token = SecureRandom.hex
    end while self.class.exists?(api_token: api_token) # this line takes care of uniqueness of api_token
  end

end