class Quizzes_learning_object < ActiveRecord::Base
  belongs_to :learning_object
  belongs_to :quizzes_quiz, :class_name => 'Quizzes::Quiz'
end