class User < ActiveRecord::Base
  has_many :setups_users
  has_many :user_to_lo_relations
  has_and_belongs_to_many :setups
end