desc "Runs the Matcher, checking event expectations"
task :matcher => :environment do
  Matcher.run
  Rails.logger.info "#{Time.zone.now.to_s(:db)} - Matcher task has run"
end
