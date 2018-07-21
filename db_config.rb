require "active_record"

options = {
  adapter: 'postgresql',
  database: 'message_board'
}

ActiveRecord::Base.establish_connection(options)
