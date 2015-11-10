class Cleanup
  attr_reader :cutoff_date

  def initialize(cutoff_date)
    @cutoff_date = cutoff_date
    check_date!
  end

  def delete!
    IncomingEvent.where("created_at < ?", cutoff_date).delete_all
  end

  private

  def check_date!
    unless cutoff_date.is_a?(Date) || cutoff_date.is_a?(Time)
      fail ArgumentError.new("Date required, got `#{cutoff_date}'.")
    end
  end

end
