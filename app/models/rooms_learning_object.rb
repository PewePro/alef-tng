class RoomsLearningObject < ActiveRecord::Base
  belongs_to :learning_object
  belongs_to :room
end