class ApiAccessToken < ActiveRecord::Base
  belongs_to :user
end