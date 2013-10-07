desc "Matcher Class"
task :matcher => :environment do
  Matcher.run
  puts "Matcher has run!"
end
