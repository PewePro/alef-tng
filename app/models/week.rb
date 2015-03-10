class Week < ActiveRecord::Base
  belongs_to :setup
  has_and_belongs_to_many :concepts
  has_many :learning_objects, through: :concepts
end