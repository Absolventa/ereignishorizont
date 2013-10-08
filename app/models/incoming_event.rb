class IncomingEvent < ActiveRecord::Base

  FORMAT = /\A[a-z0-9\s_\.-]+\Z/i

  validates :title, presence: true, format: { with: FORMAT }

  belongs_to :expected_event
  belongs_to :remote_side

  before_save :delete_white_spaces_from_title

  private

  def delete_white_spaces_from_title
    self.title = self.title.strip
  end

end
