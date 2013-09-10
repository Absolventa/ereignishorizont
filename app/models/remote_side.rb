class RemoteSide < ActiveRecord::Base

  validates :name, presence: true
  validates_uniqueness_of :name
  before_validation :generate_api_token, on: :create
  has_many :incoming_events
  validates_presence_of :api_token

  private

  def generate_api_token
    begin
      self.api_token = SecureRandom.hex
    end while self.class.exists?(api_token: api_token) # this line takes care of uniqueness of api_token
  end

end