class User < ActiveRecord::Base
  has_secure_password
  # add method - password
  # add another method - authenticate
end
