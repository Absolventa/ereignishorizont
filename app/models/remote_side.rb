class RemoteSide < ActiveRecord::Base
  validates :name, presence: true, format: { with: /\A[a-z0-9\s]+\Z/i }
  validates_uniqueness_of :name
  validates_uniqueness_of :api_token
end

