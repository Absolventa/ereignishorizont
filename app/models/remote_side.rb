class RemoteSide < ActiveRecord::Base

  # associations
  #
  #

  has_many :alarm_notifications, inverse_of: :remote_side, dependent: :nullify
  has_many :expected_events,     inverse_of: :remote_side, dependent: :nullify
  has_many :incoming_events,     inverse_of: :remote_side, dependent: :nullify

  # validations
  #
  #

  validates :name, presence: true
  validates_uniqueness_of :name
  validates_presence_of :api_token

  # callbakcs
  #
  #

  before_validation :generate_api_token, on: :create

  # instance methods
  #
  #

  private

  def generate_api_token
    begin
      self.api_token = SecureRandom.hex
    end while self.class.exists?(api_token: api_token)
  end

end
