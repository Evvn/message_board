require "active_record"

options = {
  adapter: 'postgresql',
  database: 'message_board'
}

# remove this line before going live
# ActiveRecord::Base.establish_connection(options)


# add this line before going live
ActiveRecord::Base.establish_connection( ENV['postgres://rqxuxbjdyfctkx:2c5ef8776fbe3f236206b5584562b0c45c989928053fe0f1e92c92d6e6a8cd5e@ec2-54-235-66-24.compute-1.amazonaws.com:5432/ddua5qh1quh32b'] || options)
