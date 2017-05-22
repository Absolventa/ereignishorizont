class IncomingEvent < ApplicationRecord

  FORMAT = /\A[a-z0-9\s_\.-]+\Z/i

  # associations
  #
  #

  belongs_to :expected_event
  belongs_to :remote_side

  # validations
  #
  #

  validates :title, presence: true, format: { with: FORMAT }

  # scopes
  #
  #

  scope :created_today_before, ->(deadline) do
    where("created_at > ? AND created_at <= ?", Time.now.utc.beginning_of_day, deadline)
  end

  # callbacks
  #
  #

  before_save :delete_white_spaces_from_title

  # instance methods
  #
  #

  private

  def delete_white_spaces_from_title
    self.title = self.title.strip
  end

end
