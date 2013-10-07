desc "Runs the Matcher, checking event expectations"
task :matcher => :environment do
  Matcher.run
  puts "Matcher has run!"
end
