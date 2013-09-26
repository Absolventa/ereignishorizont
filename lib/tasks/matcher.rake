desc "Matcher Class"
  task :matcher => :environment do
    matcher = Matcher.new
    #puts matcher.inspect
    matcher.run
    puts "Matcher has run!"
  end