class Quiz < ActiveRecord::Base
  belongs_to :week
  has_many :quizzes_quizzes_learning_objects, :class_name => 'Quizzes::QuizzesLearningObject'
  has_many :user_to_lo_relations_user_to_lo_relations, :class_name => 'UserToLoRelations::UserToLoRelation'
end