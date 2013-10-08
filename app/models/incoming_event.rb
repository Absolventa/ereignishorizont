class IncomingEvent < ActiveRecord::Base

  FORMAT = /\A[a-z0-9\s_\.-]+\Z/i

  validates :title, presence: true, format: { with: FORMAT }

  belongs_to :expected_event
  belongs_to :remote_side

  before_save :delete_white_spaces_from_title

  scope :created_today_before, ->(deadline) do
    where("created_at > ? AND created_at <= ?", Time.zone.now.beginning_of_day, deadline)
  end

  private

  def delete_white_spaces_from_title
    self.title = self.title.strip
  end

end
