class LearningObject < ActiveRecord::Base
  has_many :answers
  has_many :user_to_lo_relations
  belongs_to :concept
end