require 'csv'

desc "extract expected events into CSV for alerta schema"
task export_events: :environment do
  puts 'writing new csv file'
  CSV.open("expected_events.csv", "w", col_sep: ';') do |csv|
    csv << ['title', 'final_hour', 'day_of_month', 'weekdays', 'platform']
    events =  ExpectedEvent.all
    events.each do |e|

      def weekdays(event)
        weekdays = []
        weekdays.push(0) if event.weekday_0
        weekdays.push(1) if event.weekday_1
        weekdays.push(2) if event.weekday_2
        weekdays.push(3) if event.weekday_3
        weekdays.push(4) if event.weekday_4
        weekdays.push(5) if event.weekday_5
        weekdays.push(6) if event.weekday_6
        weekdays
      end

      csv << [e.title, e.final_hour, e.day_of_month || nil, weekdays(e), e.remote_side.name]
      puts e.title

    end
  end
  puts 'finished!'
end
