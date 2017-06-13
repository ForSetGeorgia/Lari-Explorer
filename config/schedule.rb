# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
#env :PATH, '/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin'
set :output, "log/cron.log"

# scrape the bank websites
# have to take into account the 4 hour time difference on production server
every :day, :at => '4:15 am' do
  rake "rates:scrape"
end
every :day, :at => '6:15 am' do
  rake "rates:scrape"
end
every :day, :at => '8:15 am' do
  rake "rates:scrape"
end
every :day, :at => '10:15 am' do
  rake "rates:scrape"
end
every :day, :at => '12:15 am' do
  rake "rates:scrape"
end
every :day, :at => '2:15 pm' do
  rake "rates:scrape"
end
every :day, :at => '4:15 pm' do
  rake "rates:scrape"
end
