desc 'Cleans up old incoming events'
task cleanup: :environment do
  retention = ENV['RETENTION_MONTHS'].to_i

  if retention > 0
    Cleanup.new(retention.months.ago.to_date).delete!
  end
end
