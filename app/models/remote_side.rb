class RemoteSide < ActiveRecord::Base

  validates :name, presence: true
  validates_uniqueness_of :name
  has_many :incoming_events
  validates_presence_of :api_token
  before_validation :generate_api_token, on: :create

  private

  def generate_api_token
    begin
      self.api_token = SecureRandom.hex
    end while self.class.exists?(api_token: api_token)
  end

end