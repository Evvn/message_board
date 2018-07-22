require "active_record"

options = {
  adapter: 'postgresql',
  database: 'message_board'
}

# remove this line before going live
# ActiveRecord::Base.establish_connection(options)


# add this line before going live
ActiveRecord::Base.establish_connection( ENV['DATABASE_URL'] || options)
