class User < ActiveRecord::Base
  has_secure_password
  validates :username, uniqueness: {case_sensitive: false}
  # add method - password
  # add another method - authenticate
end
