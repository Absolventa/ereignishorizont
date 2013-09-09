class RemoteSide < ActiveRecord::Base
  validates :title, presence: true, format: { with: /\A[a-z0-9\s]+\Z/i }
  validates_uniqueness_of :title
  validates_uniqueness_of :api_token
end

