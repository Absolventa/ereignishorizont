class IncomingEvent < ActiveRecord::Base
	validates :title, presence: true, format: { with: /\A[a-z0-9\s]+\Z/i }

	belongs_to :expected_event

	before_save :delete_white_spaces_from_title

  private
    def delete_white_spaces_from_title
      self.title = self.title.strip
    end
end

