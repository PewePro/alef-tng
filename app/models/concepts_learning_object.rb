class ConceptsLearningObject < ActiveRecord::Base
  belongs_to :concept
  belongs_to :learning_object
end