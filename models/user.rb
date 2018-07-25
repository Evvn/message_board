class User < ActiveRecord::Base
  has_secure_password
  # validates_uniqueness_of :username, case_sensitive: false
  # add method - password
  # add another method - authenticate
end
