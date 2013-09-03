class IncomingEvent < ActiveRecord::Base
	validates :title, presence: true, format: { with: /\A[a-z0-9\s]+\Z/i }

	belongs_to :expected_event

	before_save :delete_white_spaces_from_title

  # scope :matching_title, -> { where("title = ?", ExpectedEvent.new.title) }
  # scope :tracked, -> { where(IncomingEvent.tracked_at == nil) }
  # TODO are these right?

  def track! #exclamation point saves it for you
    tracked_at = Time.zone.now
  end

  private
    def delete_white_spaces_from_title
      self.title = self.title.strip
    end
end

