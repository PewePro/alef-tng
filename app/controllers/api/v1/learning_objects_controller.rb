class Api::V1::LearningObjectsController < Api::V1::BaseController

  def index
    render json: LearningObject.select(:id, :lo_id, :type, :question_text, :course_id, :difficulty, :deleted_at, :irt_difficulty), each_serializer: Api::V1::LearningObjectSerializer
  end

end
