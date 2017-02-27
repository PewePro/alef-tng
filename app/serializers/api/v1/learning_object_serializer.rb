class Api::V1::LearningObjectSerializer < Api::V1::BaseSerializer
  attributes :id, :lo_id, :type, :question_text, :course_id, :difficulty, :deleted_at, :irt_difficulty
end