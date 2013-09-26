desc "Matcher Class"
task :matcher => :environment do
  matcher = Matcher.new
  matcher.run
  # Matcher.new.run
  puts "Matcher has run!"
end