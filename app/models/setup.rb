class Setup < ActiveRecord::Base
  has_many :concepts
  has_many :user_to_lo_relations
  has_many :setups_users
  has_many :weeks
  has_many :learning_objects, through: :weeks
  has_and_belongs_to_many :users
end