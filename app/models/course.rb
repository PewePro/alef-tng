class Course < ActiveRecord::Base
  has_many :setups
  has_many :concepts
end